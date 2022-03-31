class Verification < ApplicationRecord
  attr_accessor :external_id

  has_paper_trail
  mount_uploaders :documents, DocumentUploader

  belongs_to :moderator, class_name: 'Member', required: false
  belongs_to :applicant
  has_one :account, through: :applicant

  before_validation on: :create do
    self.applicant ||= client.applicants.find_or_create_by!(external_id: external_id)
  end

  validates :country, :name, :last_name, :document_number, :documents, :reason, presence: true, on: :create
  validates :email, presence: true, email: true

  validate :validate_labels
  validate :validate_not_blocked_applicant, on: :create

  STATUSES = %w[pending refused confirmed]
  validates :status, presence: true, inclusion: { in: STATUSES }

  REASONS = %w[unban trusted_trader restore other]
  validates :restore, presence: true, inclusion: { in: REASONS }, if: :refused?

  after_update :send_notification_after_status_change

  def legacy_created
    raw_changebot['created'].to_datetime.to_i * 1000 rescue nil
  end

  def refused?
    status == 'refused'
  end

  def confirm!(user: nil)
    update! status: :confirmed, moderator: user
  end

  def refuse(user: nil, labels: [], user_comment: nil, moderator_comment: nil)
    update!(
      status:               :refused,
      user_comment:         user_comment,
      moderator:            user,
      moderator_comment:    moderator_comment,
      review_result_labels: labels
    )
  end

  def reset!(user: nil)
    update!(status: :pending, moderator_id: user)
  end

  def self.export_details
    self.find_each do |verification|
      raw = verification.raw_changebot

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


  def validate_labels
    review_result_labels.each do |label|
      errors.add :labels, "Нет такого lable #{label}" unless ReviewResultLabel.exists?(label: label)
    end
  end

  def validate_not_blocked_applicant
    errors.add :applicant_id, "Заблокированный аппликант #{applicant.external_id}" if applicant.blocked
  end

  def send_notification_after_status_change
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
