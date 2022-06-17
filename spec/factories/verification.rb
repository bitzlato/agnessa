FactoryBot.define do
  factory :verification do
    association :applicant
    association :moderator, factory: :member
    citizenship_country_iso_code { "RU" }

    sequence(:name) { |i| "name_#{i}" }
    sequence(:last_name) { |i| "LastName_#{i}" }
    sequence(:document_number) { |i| "passport_#{i}" }
    sequence(:legacy_external_id) { |i| "legacy_id_#{i}" }
    sequence(:reason) { |i| Verification::REASONS.sample }
    sequence(:email) { |i| "email#{i}@domain.com" }
    sequence(:gender) { |i| Verification::GENDERS.sample }
    sequence(:document_type) { |i| Rails.configuration.application.available_documents }
    birth_date { 19.years.ago }

    applicant_comment { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    remote_ip { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }

    verification_documents {
      applicant.account.document_types.map do |document_type|
        build(:verification_document, document_type.file_type.to_sym, document_type: document_type)
      end
    }
  end
end
