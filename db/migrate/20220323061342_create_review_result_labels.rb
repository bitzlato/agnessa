class CreateReviewResultLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :review_result_labels do |t|
      t.string :label
      t.text :description
      t.boolean :final, default: false

      t.timestamps
    end
  end
end
