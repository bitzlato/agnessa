class DocumentUploader < CarrierWave::Uploader::Base
  storage :file

  def size_range
    1000..Rails.configuration.application.fetch(:max_upload_file_size)
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
