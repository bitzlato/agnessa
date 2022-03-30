class ApplicantDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns
  end

  def self.table_columns
    %i[id first_name last_name confirmed_at last_confirmed_verification_id account_id external_id created_at blocked]
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end
