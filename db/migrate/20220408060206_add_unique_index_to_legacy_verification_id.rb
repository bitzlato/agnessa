class AddUniqueIndexToLegacyVerificationId < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, :legacy_verification_Id, unique: true
  end
end
