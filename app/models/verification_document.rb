class VerificationDocument < ApplicationRecord
  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification, required: true
  belongs_to :document_type, required: true, inverse_of: 'documents'

  delegate :content_types, to: :document_type
  validates :file, presence: true
  after_commit :delayed_update_vector, on: :create

  scope :similar_vector, ->(vector) {
    select("*, cosine_similarity(vector, '{#{vector.to_a.join(', ')}}') as similarity")
    .where.not(vector: nil)
    .order(similarity: :desc)
  }

  def file_file_name
    file.filename
  end

  before_create do
    account_document_types_ids = verification.account.document_types.pluck(:id)

    unless account_document_types_ids.include? document_type_id
      raise I18n.t('errors.messages.wrong_verification_documents')
    end
  end

  def delayed_update_vector
    if document_type.image?
      VerificationDocumentVectorUpdateJob.perform_later(id)
    end
  end

  def update_vector
    if document_type.image?
      vector = ImageVectorizer.perform(file.path)
      self.update_column(:vector, vector)
    end
  end

  def similar_vector
    self.class.similar_vector(vector).where.not({id: self.id})
  end
end
