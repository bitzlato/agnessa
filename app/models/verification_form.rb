class VerificationForm < Verification
  attr_accessor :step, :next_step

  def step
    super.to_i
  end

  def next_step=(val)
    @next_step = val.to_i
  end
end
