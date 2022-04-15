class AddBirthDateToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :birth_date, :date
    add_column :verifications, :gender, :string
  end
end
