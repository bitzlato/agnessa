class VerificationDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns + %i[legacy_verification_id applicant external_id]
  end

  def self.table_columns
    %i[id created_at country status reason name last_name document_number moderator]
  end

  CSS_STATUS_CLASSES = { 'pending' => 'badge badge-muted',
                         'refused' => 'badge badge-warning',
                         'confirmed' => 'badge badge-success', }

  CSS_REASON_CLASSES = { 'unban' => 'badge badge-warning',
                         'trusted_trader' => 'badge badge-success',
                         'restore' => 'badge badge-info',
                         'other' => 'badge badge-mute', }

  def external_id
    h.content_tag(:code, object.applicant.external_id)
  end

  def status
    h.content_tag(:span, object.status, class: CSS_STATUS_CLASSES[object.status])
  end

  def reason
    h.content_tag(:span, object.reason, class: CSS_REASON_CLASSES[object.reason])
  end
end
