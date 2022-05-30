class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification, required: true
  belongs_to :document_type, required: true, inverse_of: 'documents'

  delegate :content_types, to: :document_type

  validates :file, presence: true

  def file_file_name
    file.filename
  end
end
