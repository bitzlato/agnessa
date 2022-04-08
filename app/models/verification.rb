class Verification < ApplicationRecord
  strip_attributes replace_newlines: true, collapse_spaces: true
  # Strip off all spaces and keep only alphabetic and numeric characters
  strip_attributes only: :document_number, regex: /[^[:alnum:]_-]/

  attr_accessor :external_id

  alias_attribute :first_name, :name

  mount_uploaders :documents, DocumentUploader

  belongs_to :moderator, class_name: 'Member', required: false
  belongs_to :applicant, dependent: :destroy
  has_one :account, through: :applicant
  has_many :log_records, dependent: :destroy

  before_validation on: :create do
    self.applicant ||= client.applicants.find_or_create_by!(external_id: external_id)
  end

  before_create do
    self.first_name = first_name.to_s.upcase
    self.last_name = last_name.to_s.upcase
    self.patronymic = patronymic.to_s.upcase
    self.document_number = document_number.to_s.upcase
  end

  validates :country, :name, :last_name, :document_number, :documents, :reason, presence: true, on: :create
  validates :email, presence: true, email: true

  validate :validate_labels
  validate :validate_not_blocked_applicant, on: :create

  STATUSES = %w[pending refused confirmed]
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :by_status, ->(status) { where status: status }
  STATUSES.each do |status|
    scope status, -> { by_status status }
  end


  REASONS = %w[unban trusted_trader restore other]
  validates :reason, presence: true, inclusion: { in: REASONS }, if: :refused?

  after_update :send_notification_after_status_change
  after_create :log_creation

  def legacy_created
    raw_changebot['created'].to_datetime.to_i * 1000 rescue nil
  end

  def full_name
    [name, last_name].join(' ')
  end

  def refused?
    status == 'refused'
  end

  def confirm!(member: nil)
    ActiveRecord::Base.transaction do
      update! status: :confirmed, moderator: member
      emails = applicant.emails << self.email
      applicant.update! emails: emails, confirmed_at: Time.now, last_name: last_name, first_name: name, patronymic: patronymic, last_confirmed_verification_id: id
      log_records.create!(applicant: applicant, action: 'confirm', member: member)
    end
  end

  def refuse!(member: nil, labels: [], public_comment: nil, private_comment: nil)
    labels = labels.excluding([""])
    ActiveRecord::Base.transaction do
      update!(
        status:               :refused,
        public_comment:       public_comment,
        moderator:            member,
        private_comment:      private_comment,
        review_result_labels: labels
      )
      log_records.create!(applicant: applicant, action: 'refuse', member: member)
    end
  end

  def reset!(member: nil)
    update!(status: :pending, moderator: member)
  end


  def self.update_pending
    Verification.where(status: 'pending').find_each do |pg_verifcation|
      mongo_verification = Mongo::Verification.where('_id': pg_verifcation.legacy_verification_id).last
      next if mongo_verification.nil?

      if mongo_verification.status == 'new'
        pg_verifcation.status = 'pending'
      else
        pg_verifcation.status = mongo_verification.status
      end

      pg_verifcation.raw_changebot = mongo_verification
      pg_verifcation.public_comment = mongo_verification.comment
      emails = Array(emails).map(&:downcase).compact.uniq
      pg_verifcation.email = emails.last
      raw = pg_verifcation.raw_changebot
      case raw['cause']
      when 'trusted'
        pg_verifcation.reason = 'trusted_trader'
      when 'other'
        pg_verifcation.reason = 'other'
      when 'unlocking'
        pg_verifcation.reason = 'unban'
      when 'restoring'
        pg_verifcation.reason = 'restore'
      end
      pg_verifcation.document_number = raw['passportData']
      pg_verifcation.name = raw['name']
      pg_verifcation.last_name = raw['lastName']
      pg_verifcation.created_at = raw['created']
      pg_verifcation.updated_at = raw['lastUpdate']
      pg_verifcation.comment = raw['comment']
      pg_verifcation.save(validate: false)
    end
  end

  def self.import_documents_from_mongo
    self.find_each do |verification|
      mongo_verification = Mongo::Verification.where('_id': verification.legacy_verification_id).last

      next if mongo_verification.nil?
      # next if verification.documents != []

      grid_fs = Mongoid::GridFs
      mongo_verification['files'].each do |file_object|
        begin
          filename = [Digest::MD5.hexdigest(File.basename(file_object['filename'])), File.extname(file_object['filename'])]
          tempfile = Tempfile.new filename, binary: true

          fs = grid_fs.get(file_object['file'])
          fs.each { |chunk| tempfile.write chunk.force_encoding(Encoding::UTF_8) }

          uploader = DocumentUploader.new verification,'documents'
          uploader.store! tempfile
          verification.documents << uploader

          tempfile.close
          tempfile.unlink
        rescue CarrierWave::IntegrityError => e
          p e
        end
      end

      verification.save(validate: false)
    end
  end

  private

  def log_creation
    log_records.create!(applicant: applicant, action: 'create')
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
