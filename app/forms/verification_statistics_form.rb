# frozen_string_literal: true

class VerificationStatisticsForm
  include Virtus.model

  attribute :period, Integer
  attribute :group, String, default: 'operator'
end
