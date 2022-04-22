FactoryBot.define do
  factory :member do
    association :account
    association :user
    role { "moderator" }
    archive { false }
  end
end