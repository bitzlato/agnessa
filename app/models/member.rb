class Member < ApplicationRecord
  belongs_to :account

  validates :login, :account, presence: true
  validates :login, uniqueness: {scope: :account}

  has_secure_password

  enum role: {
    moderator: 0,
    superadmin: 1
  }

  def to_s
    login
  end
end
