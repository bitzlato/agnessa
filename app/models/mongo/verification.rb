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


    def postgres_export
        return if ::Verification.find_by(legacy_verification_id:  self['_id'])

        pg_verifcation = ::Verification.new legacy_verification_id: self['_id']

        account = Account.first
        applicant = account.applicants.find_or_create_by!(external_id: v.legacy_verification_id)
        pg_verifcation.applicant_id = applicant.id

        if self.status == 'new'
            pg_verifcation.status = 'init'
        else
            pg_verifcation.status = status
        end
        pg_verifcation.raw_changebot = self
        pg_verifcation.documents = []

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

        pg_verifcation.passport_data = raw['passportData']
        pg_verifcation.name = raw['name']
        pg_verifcation.last_name = raw['lastName']
        pg_verifcation.created_at = raw['created']
        pg_verifcation.updated_at = raw['lastUpdate']
        pg_verifcation.comment = raw['comment']


        grid_fs = Mongoid::GridFs

        self['files'].each do |file_object|
            begin
            filename = [Digest::MD5.hexdigest(File.basename(file_object['filename'])), File.extname(file_object['filename'])]
            tempfile = Tempfile.new filename, binary: true

            fs = grid_fs.get(file_object['file'])
            fs.each { |chunk| tempfile.write chunk.force_encoding(Encoding::UTF_8) }

            uploader = DocumentUploader.new pg_verifcation,'documents'
            uploader.store! tempfile
            pg_verifcation.documents << uploader

            tempfile.close
            tempfile.unlink
            rescue StandardError => e
                p e
            end
        end
        pg_verifcation.save
        p pg_verifcation
    end
end