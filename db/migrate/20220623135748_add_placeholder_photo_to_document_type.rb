class AddPlaceholderPhotoToDocumentType < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :placeholder_photo, :string
  end
end
