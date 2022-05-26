class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification
  belongs_to :document_type

  delegate :content_types, to: :document_type
end
