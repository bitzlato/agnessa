namespace :documents do
  desc "TODO"
  task convert_legacy: :environment do
    legacy_document_type = DocumentType.find_by!(title: 'legacy')
    video_document_type = DocumentType.video.first
    Verification.find_each do |v|
      puts v.id
      next unless v.legacy_documents.present? and v.legacy_documents.any?
      begin
        docs = v.legacy_documents.uniq{|x| x.path}
        docs.each do |doc|
          document_type = doc.video? ? video_document_type : legacy_document_type
          v.verification_documents.create!(document_type: document_type, file: doc)
        end

        # v.remove_legacy_documents!
        # v.save!(validate: false)
      rescue
        puts "Error #{v.id}"
      end
    end
  end
end
