class CreateDocumentTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :document_types do |t|
      t.references :account, null: false, foreign_key: true
      t.string :file_type
      t.string :title

      t.timestamps
    end
  end
end
