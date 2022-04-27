class Member < ApplicationRecord
  include Archivable

  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  enum role: {
    moderator: 0,
    superadmin: 1
  }

  def to_s
    user.email
  end
end
