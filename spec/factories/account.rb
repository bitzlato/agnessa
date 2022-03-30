FactoryBot.define do
  factory :account do
    sequence(:name) { |i| "Company #{i}" }
    sequence(:subdomain) { |i| "subdomain#{i}" }
    # sequence(:verification_callback_url) { |i| "test#{i}.test.test" }
  end
end