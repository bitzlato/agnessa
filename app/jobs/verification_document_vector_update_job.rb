class VerificationDocumentVectorUpdateJob < ApplicationJob
  def perform(verification_document_id)
    document = VerificationDocument.find(verification_document_id)
    document.update_vector
  end
end