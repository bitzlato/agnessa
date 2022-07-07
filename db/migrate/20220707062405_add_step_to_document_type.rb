class AddStepToDocumentType < ActiveRecord::Migration[6.1]
  def change
    add_column :document_types, :step, :integer
  end
end
