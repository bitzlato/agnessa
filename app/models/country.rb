class Country < ApplicationRecord
  include Archivable

  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, :title_ru, :title_en, uniqueness: true
  validates :available_documents, inclusion: { in: Rails.application.config.application.available_documents }, allow_blank: true

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
end
