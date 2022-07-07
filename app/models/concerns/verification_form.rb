module VerificationForm
  extend ActiveSupport::Concern
  DOCUMENT_POSITIONS_BY_STEP = { 1 => 3, 2 => 4 }
  VERIFICATION_ATTRS_WITH_STEP = {
    name: 1,
    last_name: 1,
    patronymic: 1,
    citizenship_country_iso_code: 1,
    birth_date: 1,
    email: 1,
    document_type: 2,
    document_number: 2,
  }.with_indifferent_access.freeze


  included do
    validates :citizenship_country_iso_code, :name, :last_name, :birth_date, :email, presence: true, if: -> { validate_step? 1 }
    validates :document_type, :document_number, presence: true, if: -> { validate_step? 2 }
    validate :permitted_citizenship, if: -> { validate_step? 1 }
    validate :over_18_years_old, if: -> { validate_step? 1 }

    validates :reason, presence: true, on: :create
    validate :validate_documents, on: :create
  end

  def next_step=(value)
    @next_step = value.to_i
  end

  def next_step
    @next_step
  end

  def current_step
    next_step - 1
  end

  def validate_step?(step_to_validate)
    return new_record? unless is_mobile?
    new_record? && step_to_validate <= current_step
  end

  private

  def validate_documents
    account.document_types.alive.ordered.each do |dt|
      errors.add :documents, "Нет документа типа #{dt.id}" unless verification_documents.find { |vd| vd.document_type_id == dt.id }
    end
  end

  def permitted_citizenship
    errors.add :citizenship_country_iso_code, I18n.t('errors.messages.citizenship_not_allowed') unless citizenship_country&.alive?
  end

  def over_18_years_old
    errors.add :birth_date, I18n.t('errors.messages.over_18_years_old') if birth_date.present? && birth_date > 18.years.ago.to_datetime
  end

end
