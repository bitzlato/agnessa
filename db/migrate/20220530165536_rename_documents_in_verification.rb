class RenameDocumentsInVerification < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :documents, :legacy_documents
  end
end
