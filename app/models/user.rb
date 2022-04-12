class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :members
  has_many :accounts, through: :members

  validates :email, presence: true
  validates :email, uniqueness: true

  def to_s
    email
  end
end
