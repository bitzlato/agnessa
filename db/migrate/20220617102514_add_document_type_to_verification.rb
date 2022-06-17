class AddDocumentTypeToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :document_type, :string
  end
end
