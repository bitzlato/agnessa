class LogRecordDecorator < ApplicationDecorator
  delegate_all

  def self.attributes
    table_columns# + %i[legacy_external_id applicant external_id]
  end

  def self.table_columns
    %i[action verification full_name document_number member created_at]
  end

  def full_name
    object.verification.full_name
  end

  def document_number
    object.verification.document_number
  end
end