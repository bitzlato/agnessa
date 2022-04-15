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

    documents { [
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg'),
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg'),
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg')
    ] }
  end
end
