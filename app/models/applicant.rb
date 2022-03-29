class Applicant < ApplicationRecord
  belongs_to :client
  has_many :verifications

  validates :external_id, presence: true, uniqueness: {scope: :client}
end
