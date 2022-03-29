class AddEmailToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :email, :string
  end
end
