class AddIndexToNumber < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, :number, unique: true
  end
end
