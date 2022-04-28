class Member < ApplicationRecord
  STATISTICS_PERIODS = [1.day, 1.month, 6.months]

  include Archivable

  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  has_many :verifications, class_name: 'Verification', foreign_key: 'moderator_id'

  enum role: {
    moderator: 0,
    superadmin: 1
  }

  def to_s
    user.email
  end
end
