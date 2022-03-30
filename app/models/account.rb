class Account < ApplicationRecord
  has_many :applicants
  has_many :verifications, through: :applicants
  has_many :members

  validates :name, :secret, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :verification_callback_url, url: true, if: :verification_callback_url?

  before_validation :generate_secret, on: :create
  before_validation :downcase_subdomain

  def recreate_secret!
    generate_secret
    save!
  end

  def public_name
    name
  end

  def host
    subdomain + '.' + Rails.application.routes.default_url_options.fetch(:host)
  end

  private

  def generate_secret
    self.secret = SecureRandom.hex(3)
  end

  def downcase_subdomain
    self.subdomain = subdomain.downcase
  end
end
