class DocumentType < ApplicationRecord
  include Archivable

  belongs_to :account
  has_many :verification_documents

  scope :ordered, -> { order :position }

  FILE_TYPES = %w[video image].freeze
  enum file_type: FILE_TYPES.each_with_object({}) { |e, a| a[e] = e }

  validates :title, presence: true
  validates :title, uniqueness: {scope: [:account_id]}

  def content_types
    case file_type
    when 'video'
      Rails.configuration.application.video_content_types
    when 'image'
      Rails.configuration.application.image_content_types
    else
      Rails.configuration.application.document_content_types
    end
  end

end
