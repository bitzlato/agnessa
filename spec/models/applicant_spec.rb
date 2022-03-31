require 'rails_helper'

describe Applicant do
  context 'block' do
    let(:applicant) { create(:applicant) }
    let(:member) { create(:member) }

    it 'writes version after block' do
      RequestStore.store[:current_member] = member
      applicant
      expect(applicant.versions.count).to eq(1)
      expect(applicant.update(blocked: true))
      expect(applicant.versions.count).to eq(2)
    end
  end
end
