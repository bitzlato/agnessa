FactoryBot.define do
  factory :country do
    iso_code { Faker::Address.country_code }
    title_ru { Faker::Address.country }
    title_en { Faker::Address.country }
    id_types { [] }

    trait :full_types do
      id_types { Rails.configuration.application.id_types }
    end
  end
end
