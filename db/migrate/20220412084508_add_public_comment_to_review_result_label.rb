class AddPublicCommentToReviewResultLabel < ActiveRecord::Migration[6.1]
  def change
    rename_column :review_result_labels, :description, :public_comment
  end
end
