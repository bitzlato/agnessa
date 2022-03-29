class AddApplicantToVerifications < ActiveRecord::Migration[6.1]
  def change
    if Verification.any?
      client = Client.first
      Verification.find_each do |v|
        next if v.legacy_verification_id.nil?

        applicant = client.applicants.find_or_create_by!(external_id: v.legacy_verification_id)
        v.update_column('applicant_id', applicant.id)
      end
    end

    change_column :verifications, :applicant_id, :bigint
    change_column_null :verifications, :applicant_id, false
    add_index :verifications, :applicant_id
    add_foreign_key :verifications, :applicants
  end
end
