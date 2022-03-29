class DocumentImageUploader < DocumentUploader
  include CarrierWave::BombShelter

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
