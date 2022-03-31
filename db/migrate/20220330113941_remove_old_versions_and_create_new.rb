class RemoveOldVersionsAndCreateNew < ActiveRecord::Migration[6.1]
  def change
    drop_table :versions
    create_table :versions do |t|
      t.references :subject, polymorphic: true
      t.jsonb :subject_changes, null: false, default: {}
      t.jsonb :state, null: false, default: {}
      t.references :member

      t.timestamps
    end
  end
end
