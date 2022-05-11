class RoleMigration < ActiveRecord::Migration[6.1]
  def change

    change_column :members, :role, :string, null: false, default: 'operator'

    Member.find_each do |member|
      case member.role
      when '0'
        member.update role: 'operator'
      when '1'
        member.update role: 'admin'
      end
    end

  end
end
