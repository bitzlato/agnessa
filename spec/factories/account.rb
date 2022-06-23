FactoryBot.define do
  factory :account do
    sequence(:name) { |i| "Company #{i}" }
    sequence(:subdomain) { |i| "subdomain#{i}" }
    sequence(:email_from) { |i| "noreply#{i}@client.com" }

    form_description { '%{email_from} %{sumdomain} %{name}'}
    # sequence(:verification_callback_url) { |i| "test#{i}.test.test" }
    #
    position { rand(1..100) }
  end
end