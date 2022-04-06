require 'rails_helper'

describe Verification do
  context 'verification' do
    let(:verification) { create :verification, document_number: 'A123 67' }

    it 'notifies after status change' do
      expect(verification.confirm!)
      expect(VerificationStatusNotifyJob.jobs.size).to eq(1)
    end

    it 'strip non alphanum chars' do
      expect(verification.document_number).to eq 'A12367'
    end
  end
end
