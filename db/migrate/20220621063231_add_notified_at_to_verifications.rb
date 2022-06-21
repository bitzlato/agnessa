class AddNotifiedAtToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :notified_at, :timestamp
  end
end
