class CreateApplicants < ActiveRecord::Migration[6.1]
  def change
    create_table :applicants do |t|
      t.references :client, null: false, foreign_key: true
      t.string :external_id, null: false

      t.timestamps
    end
    add_index :applicants, [:client_id, :external_id], unique: true
  end
end
