class MemberDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns
  end

  def self.table_columns
    %i[id role account_id user created_at]
  end
end
