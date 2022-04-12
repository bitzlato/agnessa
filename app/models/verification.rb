class Verification < ApplicationRecord
  attr_accessor :disable_notification

  strip_attributes replace_newlines: true, collapse_spaces: true
  # Strip off all spaces and keep only alphabetic and numeric characters
  strip_attributes only: :document_number, regex: /[^[:alnum:]_-]/

  attr_accessor :external_id

  alias_attribute :first_name, :name

  mount_uploaders :documents, DocumentUploader

  belongs_to :moderator, class_name: 'Member', required: false
  belongs_to :applicant
  has_one :account, through: :applicant
  has_many :log_records

  before_save do
    self.first_name = first_name.to_s.upcase
    self.last_name = last_name.to_s.upcase
    self.patronymic = patronymic.to_s.upcase if patronymic.present?
    self.document_number = document_number.to_s.upcase
  end

  validates :country, :name, :last_name, :document_number, :documents, :reason, presence: true, on: :create
  validates :email, presence: true, email: { mode: :strict }

  validates :review_result_labels, presence: true, if: :refused?
  validates :review_result_labels, absence: true, if: :confirmed?

  validate :validate_labels
  validate :validate_not_blocked_applicant, on: :create

  STATUSES = %w[pending refused confirmed]
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :by_reason, ->(reason) { where reason: reason }

  scope :by_status, ->(status) { where status: status }
  STATUSES.each do |status|
    scope status, -> { by_status status }
  end

  REASONS = %w[unban trusted_trader restore other]
  validates :reason, presence: true, inclusion: { in: REASONS }, if: :refused?

  after_update :send_notification_after_status_change
  after_create :log_creation

  def preview_image
    @preview_image ||= documents.first
  end

  def legacy_created
    external_json['created'].to_datetime.to_i * 1000 rescue nil
  end

  def full_name
    [name, last_name].join(' ')
  end

  def refused?
    status == 'refused'
  end

  def confirmed?
    status == 'confirmed'
  end

  def pending?
    status == 'pending'
  end

  def confirm!(member: nil)
    transaction do
      update! status: :confirmed, moderator: member
      emails = applicant.emails << self.email
      applicant.update! emails: emails, confirmed_at: Time.now, last_name: last_name, first_name: name, patronymic: patronymic, last_confirmed_verification_id: id
      log_records.create!(applicant: applicant, action: 'confirm', member: member)
    end
  end

  def refuse!(member: nil, labels: [], public_comment: nil, private_comment: nil)
    transaction do
      update!(
        status:               :refused,
        public_comment:       public_comment,
        private_comment:      private_comment,
        moderator:            member,
        review_result_labels: labels.map(&:presence).compact
      )
      log_records.create!(applicant: applicant, action: 'refuse', member: member)
    end
  end

  def reset!(member: nil)
    update!(status: :pending, moderator: member)
  end

  def self.export_details
    self.find_each do |verification|
      raw = verification.external_json

      case raw['cause']
      when 'trusted'
        verification.reason = 'trusted_trader'
      when 'other'
        verification.reason = 'other'
      when 'unlocking'
        verification.reason = 'unban'
      when 'restoring'
        verification.reason = 'restore'
      end

      verification.document_number = raw['passportData']
      verification.name = raw['name']
      verification.last_name = raw['lastName']
      verification.created_at = raw['created']
      verification.updated_at = raw['lastUpdate']
      verification.comment = raw['comment']

      verification.save
    end
  end

  private

  def log_creation
    log_records.create!(applicant: applicant, action: 'create', created_at: created_at)
  end

  def validate_labels
    review_result_labels.each do |label|
      errors.add :labels, "Нет такого lable #{label}" unless ReviewResultLabel.exists?(label: label)
    end
  end

  def validate_not_blocked_applicant
    errors.add :applicant_id, "Заблокированный аппликант #{applicant.external_id}" if applicant.blocked
  end

  def send_notification_after_status_change
    return if disable_notification
    return unless saved_change_to_status?

    VerificationStatusNotifyJob.perform_async(id)
    send_email_to_applicant
  end

  def send_email_to_applicant
    case status
    when 'refused'
      VerificationMailer.refused(id).deliver_now
    when 'confirmed'
      VerificationMailer.confirmed(id).deliver_now
    end
  end
end
