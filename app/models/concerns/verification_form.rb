module VerificationForm
  extend ActiveSupport::Concern

  #TODO: qwerty
  attr_accessor :next_step

  included do
    def next_step
      super.to_i
    end
  end
end
