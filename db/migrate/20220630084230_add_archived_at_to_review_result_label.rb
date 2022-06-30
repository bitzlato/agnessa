class AddArchivedAtToReviewResultLabel < ActiveRecord::Migration[6.1]
  def change
    add_column :review_result_labels, :archived_at, :timestamp
  end
end
