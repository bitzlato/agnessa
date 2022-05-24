FactoryBot.define do
  factory :document_type do
    association :account

    sequence(:title) { |i| "DocumentType #{i}" }
    sequence(:file_type) { ['video', 'image'].sample }
  end
end