class CreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :login
      t.datetime :active_at
      t.string :password_digest
      t.integer :role, default: 0
      t.timestamps
    end
  end
end
