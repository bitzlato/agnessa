class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :email, presence: true
  validates :email, uniqueness: true

  def to_s
    email
  end
end
