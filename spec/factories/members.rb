FactoryBot.define do
  factory :member do
    association :account
    association :user
    role { "moderator" }

    trait :archived do
      archived_at { Time.now }
    end
  end
end