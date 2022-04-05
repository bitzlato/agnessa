class RemoveOldVersionsAndCreateLogRecords < ActiveRecord::Migration[6.1]
  def change
    drop_table :versions
    create_table :log_records do |t|
      t.references :applicant, null: false, foreign_key: true
      t.references :verification, foreign_key: true
      t.references :member
      t.string :action, null: false

      t.timestamps
    end
  end
end
