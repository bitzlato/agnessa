class Applicant < ApplicationRecord
  strip_attributes

  belongs_to :account
  has_many :verifications
  has_many :log_records
  belongs_to :last_confirmed_verification, class_name: 'Verification', required: false

  validates :last_confirmed_verification_id, :first_name, :last_name, presence: true, if: :confirmed_at?
  validates :external_id, presence: true, uniqueness: {scope: :account}

  upsert_keys [:account_id, :external_id]

  before_update do
    self.emails = Array(self.emails).map(&:downcase).compact.uniq
  end

  def to_s
    external_id.to_s
  end

  def update_legacy_external_id!
    p2p_id = BarongClient.instance.get_p2pid_from_barong_uid(external_id)
    unless p2p_id.present?
      # Бывают ссылки вида https://check.changebot.org/verifications/verifications
      # их пропускаем
      # https://app.bugsnag.com/bitzlato/agnessa/errors/625fff2a5152420008eec2ba?filters[event.since]=30d&filters[error.status]=open
      Bugsnag.notify(StandardError.new("Unknown P2P Changebot Id: #{external_id}")) unless external_id=='verifications'
      raise HumanizedError, :invalid_barong_uid
    end
    update_column(:legacy_external_id, p2p_id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def block! member=nil
    transaction do
      update!(blocked: true)
      log_records.create!(action: 'block', member: member)
    end
  end

  def unblock! member=nil
    transaction do
      update!(blocked: false)
      log_records.create!(action: 'unblock', member: member)
    end
  end

  def unconfirm!
    update! confirmed_at: nil, last_confirmed_verification_id: nil
  end

  def verified?
    last_confirmed_verification_id.present?
  end
end
