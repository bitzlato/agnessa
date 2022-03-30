class AddApplicantToVerifications < ActiveRecord::Migration[6.1]
  def change
    change_column :verifications, :applicant_id, :bigint
    change_column_null :verifications, :applicant_id, false
    add_index :verifications, :applicant_id
    add_foreign_key :verifications, :applicants
  end
end
