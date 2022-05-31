FactoryBot.define do
  factory :verification do
    association :applicant
    association :moderator, factory: :member
    country { "ru" }

    sequence(:name) { |i| "name_#{i}" }
    sequence(:last_name) { |i| "LastName_#{i}" }
    sequence(:document_number) { |i| "passport_#{i}" }
    sequence(:legacy_external_id) { |i| "legacy_id_#{i}" }
    sequence(:reason) { |i| Verification::REASONS.sample }
    sequence(:email) { |i| "email#{i}@domain.com" }
    sequence(:gender) { |i| Verification::GENDERS.sample }
    birth_date { 19.years.ago }

    applicant_comment { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    remote_ip { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }

    verification_documents {
      docs = []
      applicant.account.document_types.each do |document_type|
        docs << build(:verification_document, document_type.file_type.to_sym, document_type: document_type)
      end
      docs
    }

    legacy_documents { [
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg'),
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg'),
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg')
    ] }
  end
end
