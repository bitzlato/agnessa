class Applicant < ApplicationRecord
  include Versionable

  belongs_to :account
  has_many :verifications
  has_many :verifications_versions, through: :verifications, source: :versions

  validates :external_id, presence: true, uniqueness: {scope: :account}

  def to_s
    # TODO Добавить ФИО из последней одобренной заявки, если нет одобренной то из последней заявки вообще
    "##{external_id}"
  end
end
