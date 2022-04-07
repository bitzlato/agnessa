class ChangeAttributesToCitext < ActiveRecord::Migration[6.1]
  def change
    change_column :verifications, :email, :citext
    Verification.find_each do |v|
      v.update_columns name: v.name.to_s.upcase, last_name: v.last_name.to_s.upcase
    end
  end
end
