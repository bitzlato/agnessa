module ImportMongo

  def self.import_documents
    Verification.order('created_at ASC').find_each do |verification|
      mongo_verification = Mongo::Verification.where('_id': verification.legacy_verification_id).last

      next if mongo_verification.nil?
      # есть уже есть документы
      next if verification.documents != []

      grid_fs = Mongoid::GridFs
      mongo_verification['files'].each do |file_object|
        begin
          filename = [Digest::MD5.hexdigest(File.basename(file_object['filename'])), File.extname(file_object['filename'])]
          tempfile = Tempfile.new filename, binary: true

          fs = grid_fs.get(file_object['file'])
          fs.each { |chunk| tempfile.write chunk.force_encoding(Encoding::UTF_8) }

          uploader = DocumentUploader.new verification,'documents'
          uploader.store! tempfile
          verification.documents << uploader

          tempfile.close
          tempfile.unlink
        rescue CarrierWave::IntegrityError => e
          p e
        end
      end

      verification.save(validate: false)
    end
  end

  # Mongo::Verification.all.order('c')no_timeout.map{ |verification| verification.import_to_postgres }
  def self.import_to_postgres
      Mongo::Verification.all.no_timeout.map do |mongo_verification|
        pg_verifcation = ::Verification.find_or_initialize_by legacy_verification_id: mongo_verification['_id']

        #Пропустить pending, так как статус мог изменитьв монного
        next unless pg_verifcation.status == 'pending'

        #Аппликант
        account = Account.first
        applicant = account.applicants.find_or_create_by!(external_id: pg_verifcation.legacy_verification_id)
        pg_verifcation.applicant_id = applicant.id

        #добавить email
        emails = Array(mongo_verification.emails).map(&:downcase).compact.uniq
        pg_verifcation.email = emails.last
        applicant.emails = emails

        #статус
        if mongo_verification.status == 'new'
          pg_verifcation.status = 'pending'
        else
          pg_verifcation.status = mongo_verification.status
        end

        pg_verifcation.raw_changebot = mongo_verification
        pg_verifcation.public_comment = mongo_verification.comment

        raw = pg_verifcation.raw_changebot


        case raw['cause']
        when 'trusted'
          pg_verifcation.reason = 'trusted_trader'
        when 'other'
          pg_verifcation.reason = 'other'
        when 'unlocking'
          pg_verifcation.reason = 'unban'
        when 'restoring'
          pg_verifcation.reason = 'restore'
        end


        pg_verifcation.document_number = raw['passportData']
        pg_verifcation.first_name = raw['name']
        pg_verifcation.last_name = raw['lastName']
        pg_verifcation.created_at = raw['created']
        pg_verifcation.updated_at = raw['lastUpdate']
        pg_verifcation.save!(validate: false)
        applicant.save!(validate: false)
      end
    end
end