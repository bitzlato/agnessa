FactoryBot.define do
  factory :document_type do
    association :account
    sequence(:title) { |i| "DocumentType #{i}" }
    active { true }

    trait :video do
      file_type { 'video' }
    end

    trait :image do
      file_type { 'image' }
    end
  end
end