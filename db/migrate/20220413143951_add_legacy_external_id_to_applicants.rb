class AddLegacyExternalIdToApplicants < ActiveRecord::Migration[6.1]
  def change
    add_column :applicants, :legacy_external_id, :string
  end
end
