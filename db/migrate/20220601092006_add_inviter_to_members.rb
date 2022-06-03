class AddInviterToMembers < ActiveRecord::Migration[6.1]
  def change
    add_reference(:members, :inviter, foreign_key: { to_table: :users })
  end
end
