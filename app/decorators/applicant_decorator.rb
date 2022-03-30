class ApplicantDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.attributes
    table_columns
  end

  def self.table_columns
    %i[id account_id applicant_name external_id created_at last_confirmed_verification_id blocked]
  end

  def applicant_name
    "#{last_verification.name} #{last_verification.last_name}"
  end

  def last_confirmed_verification_id
    last_verification.id
  end

  def confirmed_at
    last_verification.confirmed_at
  end

  private

  def last_verification
    @last_verification ||= object.verifications.last
  end
end
