class AddIsMobileToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :is_mobile, :boolean
  end
end
