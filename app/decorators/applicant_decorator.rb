class ApplicantDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns + %i[id account_id external_id]
  end

  def self.table_columns
    %i[id account_id external_id created_at]
  end
end
