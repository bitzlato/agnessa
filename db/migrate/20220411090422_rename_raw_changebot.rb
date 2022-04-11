class RenameRawChangebot < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :raw_changebot, :external_json
  end
end
