class VerificationDocument < ApplicationRecord
  mount_uploader :file, DocumentUploader

  belongs_to :verification
  belongs_to :document_type

end
