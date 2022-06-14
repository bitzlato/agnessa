class AddCitizenshipToVerification < ActiveRecord::Migration[6.1]
  def change
    add_reference :verifications, :citizenship, foreign_key: { to_table: :countries }
  end
end
