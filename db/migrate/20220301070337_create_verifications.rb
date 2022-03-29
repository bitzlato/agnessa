class CreateVerifications < ActiveRecord::Migration[6.1]

  def change
    create_table :verifications do |t|
      t.integer :applicant_id
      t.string :country, limit: 2
      t.string :legacy_verification_id
      t.integer :status
      t.string :commment
      t.integer :kind
      t.json :documents, default: []
      t.json :raw_changebot, default: {}
      t.json :params, default: {}
      t.timestamps
    end
  end
end
