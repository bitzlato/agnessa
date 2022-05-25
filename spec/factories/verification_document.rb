FactoryBot.define do
  factory :verification_document do
    association :document_type
    association :verification
    file { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg') }
  end
end