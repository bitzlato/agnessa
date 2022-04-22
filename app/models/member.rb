class Member < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :account, :user, presence: true
  validates :user, uniqueness: {scope: :account}

  def destroy
    update(archive: true)
  end

  enum role: {
    moderator: 0,
    superadmin: 1
  }

  def to_s
    user.email
  end
end
