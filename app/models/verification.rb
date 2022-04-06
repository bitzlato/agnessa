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
  validates :reason, presence: true, inclusion: { in: REASONS }, if: :refused?

  after_update :send_notification_after_status_change

  def legacy_created
    raw_changebot['created'].to_datetime.to_i * 1000 rescue nil
  end

  def refused?
    status == 'refused'
  end

  def confirm!(user: nil)
    ActiveRecord::Base.transaction do
      update! status: :confirmed, moderator: user
      applicant.update! confirmed_at: Time.now, last_name: last_name, first_name: name, last_confirmed_verification_id: id
    end
  end

  def refuse!(user: nil, labels: [], user_comment: nil, moderator_comment: nil)
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
