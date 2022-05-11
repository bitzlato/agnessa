FactoryBot.define do
  factory :applicant do
    association :account
    sequence(:external_id) { |i| "external_id_#{i}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end
end