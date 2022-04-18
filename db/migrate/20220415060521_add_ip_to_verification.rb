class AddIpToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :remote_ip, :string
    add_column :verifications, :user_agent, :string
  end
end
