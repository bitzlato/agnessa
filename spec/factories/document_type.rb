FactoryBot.define do
  factory :document_type do
    association :account
    sequence(:title) { |i| "DocumentType #{i}" }

    trait :video do
      file_type { 'video' }
    end

    trait :image do
      file_type { 'image' }
    end

    position { rand(1..100) }
  end
end