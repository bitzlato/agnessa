FactoryBot.define do
  factory :verification do
    association :applicant
    association :moderator, factory: :member
    country { "ru" }

    sequence(:name) { |i| "name_#{i}" }
    sequence(:last_name) { |i| "LastName_#{i}" }
    sequence(:passport_data) { |i| "passport_#{i}" }
    sequence(:legacy_verification_id) { |i| "legacy_id_#{i}" }
    sequence(:reason) { |i| Verification::REASONS.sample }
    sequence(:email) { |i| "email#{i}@domain.com" }

    documents { [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')))] }
  end
end
