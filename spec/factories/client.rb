FactoryBot.define do
  factory :client do
    sequence(:name) { |i| "Company #{i}" }
    sequence(:subdomain) { |i| "subdomain#{i}" }
    sequence(:email_from) { |i| "noreply#{i}@client.com" }

    # sequence(:verification_callback_url) { |i| "test#{i}.test.test" }
  end
end