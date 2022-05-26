class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification
  belongs_to :document_type


  def content_types
    document_type.content_types
  end

end
