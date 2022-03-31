class AddFormDescriptionToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :form_description, :text
  end
end
