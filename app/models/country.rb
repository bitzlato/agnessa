class Country < ApplicationRecord
  include Archivable

  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, :title_ru, :title_en, uniqueness: true
  validates_inclusion_of :available_documents, in: Rails.application.config.application.available_documents


  before_save do
    self.iso_code = iso_code.upcase
  end

  def document= val
    if self.available_documents.include?(val)
      self.available_documents.delete(val)
    else
      self.available_documents = self.available_documents.append(val).uniq
    end
  end

  def self.options_for_select
    Country.order('title_ru ASC').map { |value| [value.title_ru, value.iso_code]}
  end
end
