class VerificationForm < Verification
  attr_accessor :step

  def step
    super.to_i
  end
end
