require 'rails_helper'

describe Verification do
  context 'verification' do
    let(:verification) { create(:verification) }

    it 'notifies after status change' do
      expect(verification.confirm!)
      expect(VerificationStatusNotifyJob.jobs.size).to eq(1)
    end
  end
end
