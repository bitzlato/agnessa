class AddAPIJwkToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :api_jwt_algorithm, :string, null: false, default: 'ES256'
    add_column :accounts, :api_jwt_public_key, :jsonb
  end
end
