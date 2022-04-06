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

  def external_id
    h.content_tag(:code, object.applicant.external_id)
  end

  def status
    h.status_badge object.status
  end
end
