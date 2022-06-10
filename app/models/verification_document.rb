class VerificationDocument < ApplicationRecord
  NEIGHBOR_THRESHOLD = 0.35

  has_neighbors

  mount_uploader :file, VerificationDocumentUploader

  belongs_to :verification, required: true
  belongs_to :document_type, required: true, inverse_of: 'verification_documents'

  delegate :content_types, to: :document_type
  validates :file, presence: true
  after_commit :delayed_update_vector, on: :create

  scope :with_neighbor_threshold, ->(vector, threshold=NEIGHBOR_THRESHOLD) { where("neighbor_vector <=> '#{vector}' < #{threshold}") }

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
      vector = ImageVectorizer.new(file.path).perform
      self.update_column(:neighbor_vector, vector)
    end
  end

  def similar_documents threshold = NEIGHBOR_THRESHOLD
    nearest_neighbors(distance: "cosine").with_neighbor_threshold(neighbor_vector, threshold).where.not(id: verification.verification_documents.map(&:id))
  end
end
