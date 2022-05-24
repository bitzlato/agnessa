class VerificationDocument < ApplicationRecord
  belongs_to :verification
  belongs_to :document_type
end
