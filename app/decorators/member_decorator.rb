class MemberDecorator < ApplicationDecorator
  delegate_all

  def self.attributes
    table_columns
  end

  def self.table_columns
    %i[role user account archived_at]
  end

end
