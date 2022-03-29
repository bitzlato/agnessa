class Verification < ApplicationRecord
  has_paper_trail
  mount_uploaders :documents, DocumentUploader

  belongs_to :moderator, class_name: 'ClientUser', required: false
  belongs_to :applicant

  validates :country, :name, :last_name, :passport_data, :reason, :documents, presence: true, on: :create
  validates :email, presence: true, email: true

  validate :validate_labels

  enum status: {
    init: -1,
    refused: 0,
    confirmed: 1
  }, _default: 'init'

  enum reason: {
    unban: 0,
    trusted_trader: 1,
    restore: 2,
    other: 3
  }, _default: 'trusted_trader'

  after_update :send_notification_after_status_change

  def legacy_show
    {
      id: legacy_verification_id,
      status: status == 'confirmed' ? true : false,
      comment: raw_changebot['comment'],
      time: legacy_created || (created_at.to_i * 1000)

    }
  end

  def legacy_created
    raw_changebot['created'].to_datetime.to_i * 1000 rescue nil
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
    update!(status: :init, moderator_id: user)
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

      verification.passport_data = raw['passportData']
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

  def send_notification_after_status_change
    VerificationStatusNotifyJob.perform_async(id) if saved_change_to_status?
  end
end
