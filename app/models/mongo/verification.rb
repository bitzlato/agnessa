class Mongo::Verification
    include Mongoid::Document
    store_in collection: 'verifications'
    mount_uploaders :files, MongoDocumentUploader
    # mount_uploaders :selectFiles, MongoDocumentUploader

    field :lastUpdate, type: DateTime
    field :created, type: DateTime
    field :emails, type: Array
    field :ofMixed, type: Array
    field :denied, type: String
    field :emailClass, type: String
    field :admin, type: String
    field :confirmed, type: String
    field :passportData, type: String
    field :status, type: String
    field :lostAcc, type: String
    field :name, type: String
    field :lastName, type: String
    field :passportClass, type: String
    field :nameClass, type: String
    field :selectFiles, type: Array
    field :cause, type: String
    field :files, type: Array
    field :comment, type: String
    field :ban, type: Boolean
    field '__v', type: Integer


    # Mongo::Verification.all.order('c')no_timeout.map{ |verification| verification.import_to_postgres }
    def self.import_to_postgres
        Mongo::Verification.all.no_timeout.map do |mongo_verification|
            pg_verifcation = ::Verification.find_or_initialize_by legacy_verification_id: mongo_verification['_id']
            next if pg_verifcation.status != 'pending'

            account = Account.first
            applicant = account.applicants.find_or_create_by!(external_id: pg_verifcation.legacy_verification_id)
            pg_verifcation.applicant_id = applicant.id
            if mongo_verification.status == 'new'
                pg_verifcation.status = 'pending'
            else
                pg_verifcation.status = mongo_verification.status
            end
            pg_verifcation.raw_changebot = mongo_verification
            pg_verifcation.documents = []
            pg_verifcation.public_comment = mongo_verification.comment
            emails = Array(emails).map(&:downcase).compact.uniq
            pg_verifcation.email = emails.last
            applicant.emails = emails

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
            pg_verifcation.comment = raw['comment']
            pg_verifcation.save(validate: false)
            applicant.save(validate: false)
        end
    end
end
