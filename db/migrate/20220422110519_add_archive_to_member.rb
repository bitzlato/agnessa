class AddArchiveToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :archive, :boolean, default: false
  end
end
