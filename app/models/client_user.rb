class ClientUser < ApplicationRecord
  belongs_to :client

  validates :login, :client, presence: true
  validates :login, uniqueness: {scope: :client}

  has_secure_password

  enum role: {
    moderator: 0,
    superadmin: 1
  }
end
