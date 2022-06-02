class CreateDocumentTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :document_types do |t|
      t.references :account, null: false, foreign_key: true
      t.string :file_type, null: false
      t.string :title, null: false

      t.timestamps
    end
    add_index :document_types, [:account_id, :title], unique: true
  end
end
