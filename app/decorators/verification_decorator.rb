class VerificationDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    %i[id created_at country status reason name_dup last_name_dup email_dup document_number_dup moderator legacy_verification_id applicant external_id]
  end

  def self.table_columns
    %i[id created_at country status reason name last_name document_number moderator]
  end

  def self.short_columns
    %i[country status reason name last_name document_number]
  end

  CSS_STATUS_CLASSES = { 'pending' => 'badge badge-muted',
                         'refused' => 'badge badge-warning',
                         'confirmed' => 'badge badge-success', }

  CSS_REASON_CLASSES = { 'unban' => 'badge badge-warning',
                         'trusted_trader' => 'badge badge-success',
                         'restore' => 'badge badge-info',
                         'other' => 'badge badge-mute', }

  DUPLICATE_CLASSES = { true => 'badge badge-warning',
                        false => 'badge badge-info', }

  def document_number_dup
    duplicate_field(dup_documents, object.document_number, h.admin_verifications_path('q[document_number_eq]': object.last_name))
  end

  def name_dup
    duplicate_field(dup_names, object.name, h.admin_verifications_path('q[name_eq]': object.last_name))
  end

  def last_name_dup
    duplicate_field(dup_names, object.last_name, h.admin_verifications_path('q[last_name_eq]': object.last_name))
  end

  def email_dup
    duplicate_field(dup_emails, object.email, h.admin_verifications_path('q[email_eq]': object.email))
  end

  def external_id
    h.content_tag(:code, object.applicant.external_id)
  end

  def status
    h.content_tag(:span, I18n.t(object.status, scope: :status), class: CSS_STATUS_CLASSES[object.status])
  end

  def reason
    h.content_tag(:span, I18n.t(object.reason, scope: :reason), class: CSS_REASON_CLASSES[object.reason])
  end

  private

  def duplicate_field(scope, field, path)
    if scope.count > 1
      h.link_to h.content_tag(:span, field, class: DUPLICATE_CLASSES[true]), path, target: '_blank'
    else
      field
    end
  end

  def dup_documents
    @dup_documents ||= Verification.where(document_number: verification.document_number)
  end

  def dup_names
    @dup_names ||= Verification.where(name: verification.name).where(last_name: verification.last_name)
  end

  def dup_emails
    @πdup_emails ||= Verification.where(email: verification.email)
  end
end
