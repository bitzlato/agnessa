class VerificationDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.table_columns
    %i[id country legacy_verification_id status reason name last_name passport_data moderator created_at]
  end

  CSS_STATUS_CLASSES = { 'init' => 'badge badge-muted',
                         'refused' => 'badge badge-warning',
                         'confirmed' => 'badge badge-success', }

  CSS_REASON_CLASSES = { 'unban' => 'badge badge-warning',
                         'trusted_trader' => 'badge badge-success',
                         'restore' => 'badge badge-info',
                         'other' => 'badge badge-mute', }

  def status
    h.content_tag(:span, object.status, class: CSS_STATUS_CLASSES[object.status])
  end

  def reason
    h.content_tag(:span, object.reason, class: CSS_REASON_CLASSES[object.reason])
  end
end
