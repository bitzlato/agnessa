class AddVectorToVerificationDocument < ActiveRecord::Migration[6.1]
  def change
    add_column :verification_documents, :vector, :float, array: true
  end
end
