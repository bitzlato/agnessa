class AddCallbackUrlToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :verification_callback_url, :string
  end
end
