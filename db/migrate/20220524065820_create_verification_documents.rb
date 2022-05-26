class CreateVerificationDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :verification_documents do |t|
      t.references :verification,  foreign_key: true
      t.references :document_type, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
