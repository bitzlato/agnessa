class Member < ApplicationRecord
  STATISTICS_PERIODS = [1.day, 1.month, 6.months]
  ROLES = %w[operator admin].freeze

  include Archivable

  belongs_to :account
  belongs_to :user

  has_many :verifications, class_name: 'Verification', foreign_key: 'moderator_id'

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  validates :role, presence: true, inclusion: { in: ROLES }
  enum role: ROLES.each_with_object({}) { |e,a| a[e] = e }

  def label
    to_s
  end

  def to_s
    user.to_s
  end
end
