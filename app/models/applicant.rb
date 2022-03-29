class Applicant < ApplicationRecord
  belongs_to :account
  has_many :verifications

  validates :external_id, presence: true, uniqueness: {scope: :account}
end
