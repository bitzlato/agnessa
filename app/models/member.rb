class Member < ApplicationRecord
  include Archivable

  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}


  ROLES = %w[operator admin].freeze
  validates :role, presence: true, inclusion: { in: ROLES }


  def to_s
    user.email
  end
end
