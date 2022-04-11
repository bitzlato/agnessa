class RenameLegacyVerification < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :legacy_external_id, :legacy_external_id
    add_column :verifications, :legacy_id, :string
  end
end
