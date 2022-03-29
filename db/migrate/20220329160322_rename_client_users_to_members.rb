class RenameClientUsersToMembers < ActiveRecord::Migration[6.1]
  def change
    rename_table :client_users, :members
  end
end
