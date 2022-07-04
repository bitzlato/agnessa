module VerificationForm
  extend ActiveSupport::Concern

  included do
    attr_writer :next_step
  end

  def next_step
    @next_step.to_i
  end
end
