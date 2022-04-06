class AddSorceryFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :password_digest
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    add_column :users, :reset_password_token, :string, default: nil
    add_column :users, :reset_password_token_expires_at, :datetime, default: nil
    add_column :users, :reset_password_email_sent_at, :datetime, default: nil
    add_column :users, :access_count_to_reset_password_page, :integer, default: 0

    add_index :users, :reset_password_token
    add_column :users, :failed_logins_count, :integer, default: 0
    add_column :users, :lock_expires_at, :datetime, default: nil
    add_column :users, :unlock_token, :string, default: nil
    add_index :users, :unlock_token

    add_column :users, :remember_me_token, :string, default: nil
    add_column :users, :remember_me_token_expires_at, :datetime, default: nil

    add_index :users, :remember_me_token
  end
end
