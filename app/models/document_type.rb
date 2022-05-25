class DocumentType < ApplicationRecord
  belongs_to :account

  FILE_TYPES = %w[video image].freeze
  enum file_type: FILE_TYPES.each_with_object({}) { |e, a| a[e] = e }

end
