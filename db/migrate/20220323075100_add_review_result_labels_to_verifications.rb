class AddReviewResultLabelsToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :review_result_labels, :json, default: []
  end
end
