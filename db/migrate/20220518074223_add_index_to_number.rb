class AddIndexToNumber < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, :number
  end
end
