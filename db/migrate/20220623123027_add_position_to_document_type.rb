class AddPositionToDocumentType < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :position, :integer
  end
end
