class AddArchivedAtToDocumentType < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :archived_at, :timestamp
    DocumentType.where(active: false).update_all(archived_at: Time.now)
    remove_column :document_types, :active
  end
end
