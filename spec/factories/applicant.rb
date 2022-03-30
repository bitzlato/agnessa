FactoryBot.define do
  factory :applicant do
    association :account
    sequence(:external_id) { |i| "external_id_#{i}" }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    confirmed_at { Time.now }
  end
end