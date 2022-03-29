FactoryBot.define do
  factory :applicant do
    association :account
    sequence(:external_id) { |i| "external_id_#{i}" }
  end
end