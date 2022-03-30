class RenameClientToAccounts < ActiveRecord::Migration[6.1]
  def change
    rename_table :clients, :accounts
    rename_column :applicants, :client_id, :account_id
    rename_column :members, :client_id, :account_id
  end
end
