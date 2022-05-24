FactoryBot.define do
  factory :verification_document do
    association :account

    sequence(:title) { |i| "DocumentType #{i}" }
    sequence(:file_type) { ['video', 'image'].sample }
  end
end