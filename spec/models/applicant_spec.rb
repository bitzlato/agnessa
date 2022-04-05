require 'rails_helper'

describe Applicant do
  context 'block' do
    let(:applicant) { create(:applicant) }
    let(:member) { create(:member) }

    it 'writes version after block' do
      expect(applicant.log_records.count).to eq(0)
      expect(applicant.block!(member))
      expect(applicant.log_records.count).to eq(1)
    end
  end
end
