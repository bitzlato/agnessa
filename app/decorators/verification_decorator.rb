class VerificationDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns + %i[legacy_verification_id applicant external_id]
  end

  def self.table_columns
    %i[id created_at full_name document_number email country status reason]
  end

  def external_id
    h.content_tag(:code, object.applicant.external_id)
  end

  def email
    h.hightlight_verification_field object.email
  end

  def full_name
    h.hightlight_verification_field object.full_name
  end

  def email
    h.hightlight_verification_field object.email
  end

  def legacy_verification_id
    h.hightlight_verification_field object.legacy_verification_id
  end

  def document_number
    h.content_tag :span, class: 'text-monospace' do
      h.hightlight_verification_field object.document_number
    end
  end

  def reason
    I18n.t("attributes.reasons.#{object.reason}")
  end

  def status
    h.status_badge object.status
  end
end
