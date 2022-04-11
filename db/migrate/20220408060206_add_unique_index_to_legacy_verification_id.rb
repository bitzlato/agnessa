class AddUniqueIndexToLegacyVerificationId < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, :legacy_external_id, unique: true
  end
end
