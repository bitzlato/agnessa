module MongoImporter
  class << self
    # Mongo::Verification.all.no_timeout.map{ |verification| verification.import_to_postgres }
    def import_postgres(enable_documents: false)
      Mongo::Verification.all.no_timeout.map do |mongo_verification|
        postgres_verification = ::Verification.find_or_initialize_by legacy_external_id: mongo_verification['_id']

        applicant = set_applicant(postgres_verification)

        prepare_status(postgres_verification, mongo_verification)
        prepare_reason(postgres_verification, mongo_verification)
        prepare_emails(postgres_verification, mongo_verification, applicant)
        prepare_attributes(postgres_verification, mongo_verification)
        prepare_documents(postgres_verification, mongo_verification) if enable_documents

        postgres_verification.save!(validate: false)
        applicant.save!(validate: false)
      end
    end

    def import_documents
      Mongo::Verification.all.no_timeout.map do |mongo_verification|
        postgres_verification = ::Verification.find_by legacy_external_id: mongo_verification['_id']

        prepare_documents(postgres_verification, mongo_verification)
        postgres_verification.save(validate: false)
      end
    end


    private

    def prepare_documents(postgres_verification, mongo_verification)
      return if postgres_verification.nil?
      return if postgres_verification.documents.count == mongo_verification['files'].count

      mongo_verification['files'].each do |file_object|
        begin
          tempfile = Tempfile.new document_filename(file_object['filename']), binary: true

          fs = grid_fs.get(file_object['file'])
          fs.each { |chunk| tempfile.write chunk.force_encoding(Encoding::UTF_8) }

          uploader = DocumentUploader.new postgres_verification, 'documents'
          uploader.store! tempfile
          postgres_verification.documents << uploader

          tempfile.close
          tempfile.unlink
        rescue CarrierWave::IntegrityError => e
          Bugsnag.notify(e, ", postgres verificaion_id: #{postgres_verification.id}. filename: #{file_object['filename']}")
        end
      end
      postgres_verification.disable_sidekiq = true
    end

    def document_filename filename
      [Digest::MD5.hexdigest(File.basename(filename)), File.extname(filename)]
    end

    def account
      @account ||= Account.find_by(subdomain: 'bz')
    end

    def set_applicant(postgres_verification)
      postgres_verification.applicant = account.applicants.find_or_create_by!(external_id: postgres_verification.legacy_external_id)
    end

    def prepare_status(postgres_verification, mongo_verification)
      if mongo_verification.status == 'new'
        postgres_verification.status = 'pending'
      else
        postgres_verification.status = mongo_verification.status
      end
    end

    def prepare_reason(postgres_verification, mongo_verification)
      case mongo_verification.cause
      when 'trusted'
        postgres_verification.reason = 'trusted_trader'
      when 'other'
        postgres_verification.reason = 'other'
      when 'unlocking'
        postgres_verification.reason = 'unban'
      when 'restoring'
        postgres_verification.reason = 'restore'
      end
    end

    def prepare_attributes(postgres_verification, mongo_verification)
      postgres_verification.external_json = mongo_verification

      postgres_verification.document_number = mongo_verification.passportData
      postgres_verification.first_name = mongo_verification.name
      postgres_verification.last_name = mongo_verification.lastName
      postgres_verification.created_at = mongo_verification.created
      postgres_verification.updated_at =  mongo_verification.lastUpdate
      postgres_verification.public_comment =  mongo_verification.comment

      postgres_verification.disable_sidekiq = true
    end

    def prepare_emails(postgres_verification, mongo_verification, applicant)
      emails = Array(mongo_verification.emails).map(&:downcase).compact.uniq
      postgres_verification.email = emails.last
      applicant.emails = emails
    end

    def grid_fs
      @grid_fs ||= Mongoid::GridFs
    end
  end
end