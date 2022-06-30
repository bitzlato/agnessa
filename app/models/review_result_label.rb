class ReviewResultLabel < ApplicationRecord
  include Archivable

  validates_presence_of :label
  validates_uniqueness_of :label

  def label= value
    self['label'] = value.upcase
  end


  def self.options_for_select
    ReviewResultLabel.all.map { |value| [value.label_ru, value.label, {'data-public-comment': value.public_comment}]}
  end
end
