class AddIndexToNumber < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, [:application_id, :number], unique: true
  end
end
