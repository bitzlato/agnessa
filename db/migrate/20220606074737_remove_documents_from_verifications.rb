class RemoveDocumentsFromVerifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :verifications, :legacy_documents
  end
end
