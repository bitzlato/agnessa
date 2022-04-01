class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'citext'
    create_table :users do |t|
      t.citext :email, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_reference :members, :user, foreign_key: true
    add_index :members, [:user_id, :account_id], unique: true

    Member.find_each do |m|
      user = User.create(email: m.login, password_digest: m.password_digest)
      m.update_column(:user_id, user.id)
    end

    add_index :users, :email, unique: true
    change_column_null :members, :user_id, false

    remove_columns :members, :email, :login, :password_digest, :active_at
  end
end
