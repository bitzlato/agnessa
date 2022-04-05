class LogRecord < ApplicationRecord
  belongs_to :applicant
  belongs_to :verification, optional: true
  belongs_to :member, optional: true

  validates :applicant, :action, presence: true

  scope :ordered, ->(){ order(created_at: :desc) }
end
