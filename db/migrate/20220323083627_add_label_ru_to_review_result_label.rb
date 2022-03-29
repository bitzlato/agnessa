class AddLabelRuToReviewResultLabel < ActiveRecord::Migration[6.1]
  def change
    add_column :review_result_labels, :label_ru, :string
  end
end
