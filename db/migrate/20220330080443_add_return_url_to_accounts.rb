class AddReturnUrlToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :return_url, :string
  end
end
