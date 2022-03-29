class AddCommentToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :user_comment, :text
    add_column :verifications, :moderator_comment, :text
  end
end
