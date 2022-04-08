class AddAPIJwkToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :api_jwk, :jsonb
  end
end
