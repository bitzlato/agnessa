class AddEmailsToApplicant < ActiveRecord::Migration[6.1]
  def change
    add_column :applicants, :emails, :jsonb, default: []
  end
end
