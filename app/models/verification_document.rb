class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification
  belongs_to :document_type


  def content_type
    case document_type.file_type
    when 'video'
      Rails.configuration.application.video_content_types
    when 'image'
      Rails.configuration.application.image_content_types
    end
  end

end
