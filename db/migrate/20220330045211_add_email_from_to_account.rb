class AddEmailFromToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :email_from, :string
  end
end
