class AddNumberToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :number, :string
    Verification.update_all 'number=id'
  end
end
