class Country < ApplicationRecord
  include Archivable

  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, :title_ru, :title_en, uniqueness: true
  validates_inclusion_of :available_documents, in: Rails.application.config.application.available_documents


  before_save do
    self.iso_code = iso_code.upcase
  end

  def toggle_id_type!(id_type)
    if available_documents.include?(id_type)
      available_documents.delete(id_type)
      save!
    else
      update! available_documents: id_types.append(id_type).uniq
    end
  end
end
