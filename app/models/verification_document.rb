class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification, required: true
  belongs_to :document_type, required: true

  delegate :content_types, to: :document_type
end
