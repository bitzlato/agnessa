class Applicant < ApplicationRecord
  belongs_to :client
  has_many :verifications

  validates :external_id, presence: true, uniqueness: {scope: :client}

  def to_s
    # TODO Добавить ФИО из последней одобренной заявки, если нет одобренной то из последней заявки вообще
    "##{external_id}"
  end
end
