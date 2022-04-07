class RenameComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :user_comment, :public_comment
    rename_column :verifications, :moderator_comment, :private_comment
  end
end
