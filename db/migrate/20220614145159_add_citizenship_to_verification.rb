class AddCitizenshipToVerification < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :country,:citizenship_country_iso_code
  end
end
