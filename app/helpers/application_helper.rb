module ApplicationHelper
  STATUS_CLASSES = { 'pending' => 'badge badge-warning',
                     'refused' => 'badge badge-secondary',
                     'confirmed' => 'badge badge-success' }

  def status_badge(status)
    content_tag(:span, t(status, scope: :status), class: STATUS_CLASSES[status])
  end

  VERIFICATION_QUERY = :id_or_applicant_legacy_external_id_or_applicant_external_id_or_legacy_external_id_or_document_number_or_name_or_last_name_or_patronymic_or_email_cont
  APPLICANT_QUERY = :first_name_or_last_name_or_patronymic_or_external_id_cont

  def hightlight_verification_field(value)
    return middot if value.blank?
    query = params.dig(:q, VERIFICATION_QUERY)
    return value unless query.present?
    highlight value, Regexp.new(query, true)
  end

  def warning
    '⚠️'.html_safe
  end

  def statused_verifications
    status_from_query = request.query_parameters.fetch(:q, {}).fetch(:status_eq, nil)
    scope = current_account.verifications

    status_from_query.blank? ? scope : scope.by_status(status_from_query)
  end

  def warning_flag(flag)
    content_tag :span, class: 'mr-1' do
      warning
    end if flag
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def title_with_counter(title, count, hide_zero: true, css_class: nil)
    buffer = ''
    buffer += title

    buffer += ' '
    text = hide_zero && count.to_i.zero? ? '' : count.to_s
    buffer += content_tag(:span, "(#{text})", class: css_class, data: { title_counter: true, count: count.to_i }) if count > 0

    buffer.html_safe
  end

  def sort_column(column, title)
    return column unless defined? q
    sort_link q, column, title
  end

  def hided_columns
    # TODO
    []
  end

  def back_link(url = nil)
    link_to ('&larr; ' + t('.back')).html_safe, url || root_path
  end

  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def bg_warning_class(flag)
    flag ? "border border-warning" : ''
  end

  def warining_table_class(css_classes, flag)
    flag ? "#{css_classes} table-warning" : css_classes
  end

  def duration_of_interval_in_words(duration)
    duration = ActiveSupport::Duration.build(duration) unless duration.is_a?(ActiveSupport::Duration)
    duration.parts.map do |k, v|
      if v > 0
        "#{v.to_i} #{t(k.to_s.singularize, scope: 'datetime.prompts')}"
      end
    end.compact.join(', ')
  end
end
