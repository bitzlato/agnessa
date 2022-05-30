require 'carrierwave/processing/mini_magick'
class VerificationDocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::BombShelter
  include CarrierWave::Video::Thumbnailer
  include CarrierWave::MiniMagick
  # include SecureUniqueFilename

  storage :file

  THUMBNAIL_WIDTH=160
  THUMBNAIL_HEIGHT=120

  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: THUMBNAIL_WIDTH, strip: true, logger: Rails.logger}], if: :video?

    def full_filename for_file
      png_name for_file, version_name
    end

    process resize_to_fit: [THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT], if: :image?
    process convert: 'png', if: :image?
  end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end

  def size_range
    Rails.configuration.application.min_upload_file_size..Rails.configuration.application.max_upload_file_size
  end

  def extension
    file.extension.downcase
  end

  def video?(_version = nil)
    content_type.include? 'video'
  end

  def image?(_version = nil)
    content_type.include? 'image'
  end

  def content_type_allowlist
    # Rails.configuration.application.document_content_types
    model.content_types
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def protect_from_image_bomb!(new_file)
    super new_file if image?
  end
end
