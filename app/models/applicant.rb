class Applicant < ApplicationRecord
  belongs_to :account
  has_many :verifications
  has_many :log_records
  belongs_to :last_confirmed_verification, class_name: 'Verification', required: false

  validates :last_confirmed_verification_id, :first_name, :last_name, presence: true, if: :confirmed_at?
  validates :external_id, presence: true, uniqueness: {scope: :account}

  def to_s
    # TODO Добавить ФИО из последней одобренной заявки, если нет одобренной то из последней заявки вообще
    "##{external_id}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def block! member=nil
    ActiveRecord::Base.transaction do
      update!(blocked: true)
      log_records.create!(action: 'block', member: member)
    end
  end

  def unblock! member=nil
    ActiveRecord::Base.transaction do
      update!(blocked: false)
      log_records.create!(action: 'unblock', member: member)
    end
  end
end
