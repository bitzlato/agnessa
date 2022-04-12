class MongoImporter
  def import_verifications(with_documents: false)
    bar = ProgressBar.create(title: "Items", starting_at: 0, total: Mongo::Verification.count)
    back_sort_scope.each do |mongo_verification|
      begin
        verification = ::Verification.find_or_initialize_by(legacy_external_id: mongo_verification['_id'])
        verification.disable_notification = true
        applicant = get_applicant(mongo_verification)
        verification.applicant = applicant
        verification.status = get_status(mongo_verification)
        verification.reason = get_reason(mongo_verification)
        verification.email = get_last_email(mongo_verification)
        applicant.emails = get_emails(mongo_verification)
        verification.attributes = get_attributes(mongo_verification)

        import_verification_documents(verification, mongo_verification) if with_documents

        applicant.save!(validate: false)
        verification.save!(validate: false)
      rescue
        Bugsnag.notify(StandardError.new("Cant Import Verification with id: #{mongo_verification['_id']}"))
      end
      bar.increment
    end
  end

  def import_documents
    bar = ProgressBar.create(title: "Items", starting_at: 0, total: Mongo::Verification.count)
    back_sort_scope.each do |mongo_verification|
      verification = ::Verification.find_by(legacy_external_id: mongo_verification['_id'])
      if verification.present?
        import_verification_documents(verification, mongo_verification)
        verification.save(validate: false)
      end
      bar.increment
    end
  end

  private


  def back_sort_scope
    Mongo::Verification.collection.aggregate([{'$sort' => {'created' => -1}}], {allow_disk_use: true})
  end
  def import_verification_documents(verification, mongo_verification)
    return if verification.documents.count == mongo_verification['files'].count

    mongo_verification['files'].each do |file_object|
      begin
        tempfile = Tempfile.new document_filename(file_object['filename']), binary: true

        fs = grid_fs.get(file_object['file'])
        fs.each { |chunk| tempfile.write chunk.force_encoding(Encoding::UTF_8) }

        uploader = DocumentUploader.new verification, 'documents'
        uploader.store! tempfile
        verification.documents << uploader

        tempfile.close
        tempfile.unlink
      rescue CarrierWave::IntegrityError => e
        Bugsnag.notify(e, ", postgres verificaion_id: #{verification.id}. filename: #{file_object['filename']}")
      end
    end
  end

  def document_filename filename
    [Digest::MD5.hexdigest(File.basename(filename)), File.extname(filename)]
  end

  def account
    @account ||= Account.find_by(subdomain: 'bz')
  end

  def get_applicant(mongo_verification)
    uid = barong_client.get_uid_from_changebot_id(mongo_verification['_id'])
    external_id = uid.present? ? uid : "LEGACY_#{app.external_id}"
    account.applicants.find_or_create_by!(external_id: external_id)
  end

  def get_status(mongo_verification)
    case mongo_verification.status
    when 'new'
      'pending'
    else
      mongo_verification.status
    end
  end

  def get_reason(mongo_verification)
    case mongo_verification.cause
    when 'trusted'
      'trusted_trader'
    when 'other'
      'other'
    when 'unlocking'
      'unban'
    when 'restoring'
      'restore'
    end
  end

  def get_attributes(mongo_verification)
    {
      external_json: mongo_verification,
      document_number:  mongo_verification.passportData,
      first_name:  mongo_verification.name,
      last_name:  mongo_verification.lastName,
      created_at:  mongo_verification.created,
      updated_at:  mongo_verification.lastUpdate,
      public_comment:  mongo_verification.comment,
    }
  end

  def get_last_email(mongo_verification)
    Array(mongo_verification.emails).map(&:downcase).compact.uniq.last
  end

  def get_emails(mongo_verification)
    Array(mongo_verification.emails).map(&:downcase).compact.uniq
  end

  def grid_fs
    @grid_fs ||= Mongoid::GridFs
  end

  def barong_client
    BarongClient.instance
  end
end