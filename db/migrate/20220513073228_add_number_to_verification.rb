class AddNumberToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :number, :string
    Verification.all.find_each do |v|
      v.update_column('number', v.id)
    end
  end
end
