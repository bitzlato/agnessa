class CountryExport

  EXCLUDE = ['Afghanistan', 'Albania', 'Algeria', 'Bangladesh', 'Bolivia (Plurinational State of)', 'Myanmar',
'Burundi', 'Central African Republic', 'Guinea', 'Guinea-Bissau', 'Cuba', "Korea (Democratic People's Republic of)", 'Ghana', 'Guinea-Bissau', 'Haiti', 'Iran (Islamic Republic of)', 'Iraq', 'Lebanon', 'Libya', 'Mali', 'Myanmar', 'Nicaragua', 'Pakistan', 'Qatar', 'Saudi Arabia', 'Somalia', 'South Sudan', 'Sudan', 'Syrian Arab Republic', 'Tunisia', 'Uganda', 'United States of America', 'Vanuatu', 'Venezuela (Bolivarian Republic of)', 'Yemen', 'Zimbabwe'].freeze
  EXCLUDE_CODES = %w[AF AL DZ BD BO MM BI CF GN GW CU KP GH GW HT IR IQ LB LY ML MM NI PK QA SA SO SS SD SY TN UG US VU
VE YE ZW].freeze

  def initialize; end

  def call
    ISO3166::Country.all.each do |country|
      next if EXCLUDE_CODES.include? country.alpha2

      Country.create iso_code: country.alpha2, title_ru: country.translations['ru'], title_en: country.translations['en']
    end
  end
end