FactoryBot.define do
  factory :country do
    iso_code { Faker::Address.country_code }
    title_ru { Faker::Address.country }
    title_en { Faker::Address.country }
    available_documents { [] }

    trait :full_types do
      available_documents { Rails.configuration.application.available_documents }
    end
  end
end
