class DropVerfificationDocumentsOldVectorColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :verification_documents, :vector
  end
end
