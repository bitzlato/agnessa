class AddVisibleToDocumentType < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :active, :boolean, default: true
  end
end
