class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification, required: true
  belongs_to :document_type, required: true, inverse_of: 'documents'

  delegate :content_types, to: :document_type
  validates :file, presence: true
  validate :account_document_type

  def file_file_name
    file.filename
  end

  private

  def account_document_type
    account_document_types_ids = verification.account.document_types.pluck(:id)

    unless account_document_types_ids.include? document_type_id
      raise I18n.t('errors.messages.wrong_verification_documents')
    end
  end
end
