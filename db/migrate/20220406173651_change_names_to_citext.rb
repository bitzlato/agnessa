class ChangeNamesToCitext < ActiveRecord::Migration[6.1]
  def change
    change_column :verifications, :name, :citext
    change_column :verifications, :last_name, :citext
    change_column :verifications, :patronymic, :citext

    change_column :applicants, :first_name, :citext
    change_column :applicants, :last_name, :citext

    add_column :applicants, :patronymic, :citext
  end
end
