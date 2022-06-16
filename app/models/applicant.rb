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
    # TODO Добавить ФИО из последней одобренной заявки, если нет одобренной то из последней заявки вообще
    "##{external_id}"
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

  def verified?
    last_confirmed_verification_id.present?
  end
end
