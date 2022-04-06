class AddPatronymicToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :patronymic, :string
  end
end
