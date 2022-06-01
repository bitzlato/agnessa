FactoryBot.define do
  factory :verification_document do
    association :document_type
    association :verification

    trait :video do
      association :document_type, :video
      file { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/video.mp4')), 'video/mp4') }
    end

    trait :image do
      association :document_type, :image
      file { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg') }
    end
  end
end