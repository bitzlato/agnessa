class FillCountryDocuments < ActiveRecord::Migration[6.1]
  def change
    Country.update_all(available_documents: Rails.application.config.application.available_documents)
  end
end
