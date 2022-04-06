module ApplicationHelper

  # TODO Вынести в Uploader
  VIDEO_EXTS = %w[.mp4 .mov]

  def sort_column(column, title)
    sort_link q, column, title
  end

  def test_new_client_verification_url(short=false)
    if short
      client_short_new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('test', current_account.secret))
    else
      new_client_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('test', current_account.secret))
    end
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
end
