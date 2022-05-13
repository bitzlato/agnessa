class RoleMigration < ActiveRecord::Migration[6.1]
  def change

    change_column :members, :role, :string, null: false, default: 'operator'

    Member.where(role: '0').update_all role: 'operator'
    Member.where(role: '1').update_all role: 'admin'
  end
end
