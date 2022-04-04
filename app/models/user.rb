class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, uniqueness: true

  belongs_to :member

  def to_s
    login
  end
end
