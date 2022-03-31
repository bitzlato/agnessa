module ApplicationHelper

  # TODO Вынести в Uploader
  VIDEO_EXTS = %w[.mp4 .mov]

  def sort_column(column, title)
    sort_link q, column, title
  end

  def test_new_client_verification_url
    new_client_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('test', current_account.secret))
  end

  def hided_columns
    # TODO
    []
  end

  def back_link(url = nil)
    link_to ('&larr; ' + t('.back')).html_safe, url || root_path
  end

  def image_or_video(url)
    ext = File.extname(url).downcase
    if VIDEO_EXTS.include? ext
      tag.video(tag.source(src: url), controls: 'controls')
    else
      image_tag url
    end
  end

  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def history_verification_changes version
    changes = version.subject_changes.except('created_at', 'updated_at')
    if changes['id'].present? and changes['id'].first == nil
      return 'создана новая заявка'
    end
    subject_class = version.subject.class
    changes.map do |k, v|
      "#{subject_class.human_attribute_name(k)}: #{history_verification_changes_values(subject_class, k, v)}"
    end.join('<br>').html_safe
  end

  def history_verification_changes_values subject_class, key, values
    values = case key.to_sym
             when :status
               values.map { |v| subject_class.human_enum_name(:status, v) }
             else
               values
             end

    values.join(' => ')
  end

  def history_blocked_status version
    values = version.subject_changes['blocked']
    values.last ? 'заблокирован' : 'разблокирован'
  end
end
