class Country < ApplicationRecord
  validates :title_en, :title_ru, :iso_code, presence: true
  validates :iso_code, uniqueness: true

  before_save do
    self.iso_code = iso_code.upcase
  end
end
