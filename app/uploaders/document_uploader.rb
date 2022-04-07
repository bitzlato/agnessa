class DocumentUploader < CarrierWave::Uploader::Base
  storage :file

  def size_range
    Rails.configuration.application.min_upload_file_size..Rails.configuration.application.max_upload_file_size
  end

  def extension
    file.extension.downcase
  end

  def mime_type
    MIME::Types.type_for(file).first.content_type
  end

  def video?
    mime_type.include? 'video'
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
