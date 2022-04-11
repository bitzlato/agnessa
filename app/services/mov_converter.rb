class MovConverter
  def convert
    Verification.all.find_each do |verification|
      verification.documents.each do |document|
        if File.extname(document.path).downcase == '.mov'
          convert_to_mp4(document)
        end
      end
    end
  end

  private

  def convert_to_mp4 document
    mp4_path = "#{File.dirname(document.path)}/#{File.basename(document.path, File.extname(document.path))}.mp4"
    status = system("ffmpeg -y -i #{document.path}  #{mp4_path}")
    if status
      verification = document.model
      uploader = DocumentUploader.new verification, 'documents'
      uploader.store! File.open mp4_path
      verification.documents << uploader
      verification.save(validate: false)
    end
  end
end