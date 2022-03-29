class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.string :secret, null: false

      t.timestamps
    end

    add_index :clients, :subdomain, unique: true
  end
end
