module MongoImporter

  # Mongo::Verification.all.no_timeout.map{ |verification| verification.import_to_postgres }
  def self.import_to_postgres
    Mongo::Verification.all.no_timeout.map do |mongo_verification|
      postgres_verification = ::Verification.find_or_initialize_by legacy_external_id: mongo_verification['_id']

      applicant = set_applicant(postgres_verification)

      prepare_status(postgres_verification, mongo_verification)
      prepare_reason(postgres_verification, mongo_verification)
      prepare_emails(postgres_verification, mongo_verification, applicant)
      prepare_attributes(postgres_verification, mongo_verification)

      postgres_verification.save!(validate: false)
      applicant.save!(validate: false)
    end
  end


  private

  def self.account
    @account ||= Account.find_by(subdomain: 'bz')
  end

  def self.set_applicant(postgres_verification)
    postgres_verification.applicant = account.applicants.find_or_create_by!(external_id: postgres_verification.legacy_external_id)
  end

  def self.prepare_status(postgres_verification, mongo_verification)
    if mongo_verification.status == 'new'
      postgres_verification.status = 'pending'
    else
      postgres_verification.status = mongo_verification.status
    end
  end

  def self.prepare_reason(postgres_verification, mongo_verification)
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

  def self.prepare_attributes(postgres_verification, mongo_verification)
    postgres_verification.external_json = mongo_verification

    postgres_verification.document_number = mongo_verification.passportData
    postgres_verification.first_name = mongo_verification.name
    postgres_verification.last_name = mongo_verification.lastName
    postgres_verification.created_at = mongo_verification.created
    postgres_verification.updated_at =  mongo_verification.lastUpdate
    postgres_verification.public_comment =  mongo_verification.comment

    postgres_verification.disable_sidekiq = true
  end

  def self.prepare_emails(postgres_verification, mongo_verification, applicant)
    emails = Array(mongo_verification.emails).map(&:downcase).compact.uniq
    postgres_verification.email = emails.last
    applicant.emails = emails
  end

end