class AddFieldsToApplicant < ActiveRecord::Migration[6.1]
  def change
    add_column :applicants, :first_name, :string
    add_column :applicants, :last_name, :string
    add_column :applicants, :last_confirmed_verification_id, :bigint
    add_column :applicants, :confirmed_at, :datetime
  end
end
