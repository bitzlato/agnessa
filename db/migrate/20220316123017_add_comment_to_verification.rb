class AddCommentToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :comment, :string
  end
end
