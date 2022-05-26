class CreateDocumentTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :document_types do |t|
      t.references :account,  foreign_key: true
      t.string :file_type
      t.string :title

      t.timestamps
    end
    add_index :document_types, [:title, :account_id], unique: true
  end
end
