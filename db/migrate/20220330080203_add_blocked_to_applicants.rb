class AddBlockedToApplicants < ActiveRecord::Migration[6.1]
  def change
    add_column :applicants, :blocked, :boolean, default: false, null: false
  end
end
