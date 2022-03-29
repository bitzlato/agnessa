FactoryBot.define do
  factory :client_user do
    association :client
    sequence(:login) { |i| "login_#{i}" }
    role { "moderator" }
    password { SecureRandom.hex(3) }
  end
end