FactoryBot.define do
  factory :member do
    association :account
    association :user
    role { 'operator' }

    trait :archived do
      archived_at { Time.now }
    end

    trait :admin do
      role { 'admin'}
    end

    trait :operator do
      role { 'operator'}
    end
  end
end