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

  def external_id
    h.content_tag :code do
      h.hightlight_verification_field object.external_id
    end
  end
end
