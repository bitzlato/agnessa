class AddUniqueIndexOnClientUserLogin < ActiveRecord::Migration[6.1]
  def change
    change_column_null :client_users, :login, false
    add_index :client_users, [:client_id, :login], unique: true
  end
end
