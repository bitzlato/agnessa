class Country < ApplicationRecord
  include Archivable

  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, :title_ru, :title_en, uniqueness: true
  validates_inclusion_of :id_types, in: Rails.application.config.application.id_types


  before_save do
    self.iso_code = iso_code.upcase
  end

  def add_type(id_type)
    return if id_types.include?(id_type)

    update! id_types: id_types.append(id_type).uniq
  end

  def remove_type(id_type)
    return unless id_types.include?(id_type)

    id_types.delete(id_type)
    save!
  end

end
