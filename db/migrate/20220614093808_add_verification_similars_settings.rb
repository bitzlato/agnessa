class AddVerificationSimilarsSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :calculate_similarity, :boolean, default: false
    add_column :accounts, :document_similarity_threshold, :integer, default: 70
  end
end
