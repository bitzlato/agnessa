class AddArchivedAtToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :archived_at, :timestamp
  end
end
