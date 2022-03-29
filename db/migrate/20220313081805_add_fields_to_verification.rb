class AddFieldsToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :reason, :integer
    add_column :verifications, :name, :string
    add_column :verifications, :last_name, :string
    add_column :verifications, :passport_data, :string
  end
end
