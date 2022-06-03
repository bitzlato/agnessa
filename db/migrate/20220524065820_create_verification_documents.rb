class CreateVerificationDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :verification_documents do |t|
      t.references :verification, null: false, foreign_key: true
      t.references :document_type, null: false, foreign_key: true
      t.string :file, null: false

      t.timestamps
    end
  end
end
