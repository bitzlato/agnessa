class Applicant < ApplicationRecord
  belongs_to :account
  has_many :verifications
  belongs_to :last_confirmed_verification, class_name: 'Verification'

  validates :external_id, presence: true, uniqueness: {scope: :account}

  def to_s
    # TODO Добавить ФИО из последней одобренной заявки, если нет одобренной то из последней заявки вообще
    "##{external_id}"
  end
end
