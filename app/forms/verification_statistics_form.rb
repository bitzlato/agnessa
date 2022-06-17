# frozen_string_literal: true

class VerificationStatisticsForm
  TIME_AGO_VALUES = [1.day, 1.month, 6.months]
  DATE_GROUPS = [:day, :month]
  SUBJECTS = [:moderator_id, :reason, :status]

  include Virtus.model

  attribute :ago, Integer
  attribute :subject_group, String, default: 'moderator_id'
  attribute :date_group, String, default: 'day'

  def date_group= val
    if DATE_GROUPS.include?(val.to_sym)
      super
    end
  end

  def subject_group= val
    if SUBJECTS.include?(val.to_sym)
      super
    end
  end
end
