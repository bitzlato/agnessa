class RenameLegacyVerification < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :legacy_verification_id, :legacy_external_id
  end
end
