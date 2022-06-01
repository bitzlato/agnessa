class Country < ApplicationRecord
  include Archivable

  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, :title_ru, :title_en, uniqueness: true
  validates_inclusion_of :id_types, in: Rails.application.config.application.id_types


  before_save do
    self.iso_code = iso_code.upcase
  end

  def toggle_id_type(id_type)
    if id_types.include?(id_type)
      id_types.delete(id_type)
      save!
    else
      update! id_types: id_types.append(id_type).uniq
    end
  end
end
