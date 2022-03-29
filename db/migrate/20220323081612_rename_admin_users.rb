class RenameAdminUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :admin_users, :client_users
    add_column :client_users, :client_id, :bigint
    if ClientUser.any?
      ClientUser.update_all(client_id: Client.first.id)
    end

    change_column_null :client_users, :client_id, false
    add_index :client_users, :client_id
    add_foreign_key :client_users, :clients
  end
end
