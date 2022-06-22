class CountrySeed
  def initialize; end
  def call
    ISO3166::Country.all.each do |country|
      next if  Rails.configuration.application.exclude_country_codes.include? country.alpha2

      Country.create iso_code: country.alpha2, title_ru: country.translations['ru'], title_en: country.translations['en'], available_documents:  Rails.application.config.application.available_documents
    end

    Country.create iso_code: 'OT', title_ru: 'Другая', title_en: 'Other'
  end
end