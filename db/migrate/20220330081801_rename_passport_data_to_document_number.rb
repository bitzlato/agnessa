class RenamePassportDataToDocumentNumber < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :passport_data, :document_number
  end
end
