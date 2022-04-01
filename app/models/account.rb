class Account < ApplicationRecord
  has_many :applicants
  has_many :verifications, through: :applicants
  has_many :members
  has_many :users, through: :members

  validates :name, :secret, :email_from, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :verification_callback_url, url: true, if: :verification_callback_url?
  validates :email_from, email: true
  validates :return_url, url: true, if: :return_url?

  before_validation :set_secret, on: :create
  before_validation :downcase_subdomain

  def recreate_secret!
    update_column(:secret, generate_secret)
  end

  def public_name
    name
  end

  def host
    subdomain + '.' + Rails.application.routes.default_url_options.fetch(:host)
  end


  def form_description_interpolated
    Interpolation.interpolate form_description, interpolate_hash
  end

  def interpolate_hash
    {
      email_from: email_from,
      name: name,
      subdomain: subdomain
    }
  end

  private

  def set_secret
    self.secret = generate_secret
  end

  def generate_secret
    SecureRandom.hex(3)
  end

  def downcase_subdomain
    self.subdomain = subdomain.downcase
  end
end
