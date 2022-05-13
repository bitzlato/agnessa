class Member < ApplicationRecord
  STATISTICS_PERIODS = [1.day, 1.month, 6.months]

  include Archivable

  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  ROLES = %w[operator admin].freeze
  validates :role, presence: true, inclusion: { in: ROLES }

  def operator?
    role == 'role'
  end

  def admin?
    role == 'admin'
  end

  has_many :verifications, class_name: 'Verification', foreign_key: 'moderator_id'

  def to_s
    user.email
  end
end
