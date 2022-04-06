class ApplicationDecorator < Draper::Decorator
  TEXT_RIGHT = %i[].freeze

  def self.table_columns
    object_class.attribute_names.map(&:to_sym)
  end

  def self.table_th_class(column)
    return 'text-right' if TEXT_RIGHT.include? column.to_sym
  end

  def self.table_td_class(column)
    table_th_class column
  end

  def self.table_tr_class(record); end

  def self.attributes
    table_columns
  end

  def updated_at
    present_time object.updated_at
  end

  def created_at
    present_time object.created_at
  end

  private

  def present_time(time)
    return if time.nil?
    return time.iso8601 if h.request.format.xlsx?

    h.content_tag :span, class: 'text-nowrap' do
      I18n.l time, format: :long
    end
  end
end
