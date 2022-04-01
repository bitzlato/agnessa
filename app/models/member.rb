class Member < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  enum role: {
    moderator: 0,
    superadmin: 1
  }
end
