FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "test#{i}@test.test" }
    password { SecureRandom.hex(3) }
  end
end