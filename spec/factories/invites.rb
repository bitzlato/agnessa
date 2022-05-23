# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    account
    association :inviter, factory: :user
    email { Faker::Internet.email }
  end
end
