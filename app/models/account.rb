class Account < ApplicationRecord
  has_many :applicants
  has_many :verifications, through: :applicants
  has_many :members
  has_many :users, through: :members
  has_many :log_records, through: :applicants
  has_many :invites
  has_many :document_types

  validates :name, :secret, :email_from, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :verification_callback_url, url: true, if: :verification_callback_url?
  validates :email_from, email: { mode: :strict }
  validates :return_url, url: true, if: :return_url?
  validates :subdomain, exclusion: Rails.configuration.application.reserved_subdomains
  validates :document_similarity_threshold, numericality: { in: 40..100 }

  before_validation :set_secret, on: :create
  before_validation :downcase_subdomain

  after_create :create_document_types

  def recreate_secret!
    update_column(:secret, generate_secret)
  end

  def public_name
    name
  end

  def to_s
    name
  end

  def host
    subdomain + '.' + Rails.application.routes.default_url_options.fetch(:host)
  end


  def form_description_interpolated
    ::Interpolation.interpolate form_description, interpolate_hash
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

  def create_document_types
    [
      { file_type: 'image', title: 'Селфи с документом и листком бумаги, с текущей датой и фразой «для криптобанка Bitzlato»', calculate_similarity: true },
      { file_type: 'image', title: 'Фотография или скан действительного документа, удостоверяющего личность' }
    ].each do |attributes|
      document_types.create!(attributes)
    end
  end
end
