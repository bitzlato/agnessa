class Country < ApplicationRecord
  validates :title_en, :title_ru, :code, presence: true
  validates :code, uniqueness: true

  before_save do
    self.code = code.upcase
  end
end
