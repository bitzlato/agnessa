class AddModeratorToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :moderator_id, :integer
  end
end
