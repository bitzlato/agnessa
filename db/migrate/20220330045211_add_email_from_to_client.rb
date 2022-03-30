class AddEmailFromToClient < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :email_from, :string
  end
end
