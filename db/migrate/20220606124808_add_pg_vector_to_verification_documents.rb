class AddPgVectorToVerificationDocuments < ActiveRecord::Migration[6.1]
  def change
    enable_extension "vector"
    add_column :verification_documents, :neighbor_vector, :vector, limit: 512
    add_index :verification_documents, :neighbor_vector, using: :ivfflat, opclass: :vector_cosine_ops
  end
end
