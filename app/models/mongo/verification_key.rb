class Mongo::VerificationKey
    include Mongoid::Document
    store_in collection: 'verifications_keys'

    field :value, type: :string
end