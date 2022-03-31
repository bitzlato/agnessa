require 'rails_helper'

describe Applicant do
  context 'block' do
    let(:applicant) { create(:applicant) }
    let(:member) { create(:member) }

    it 'writes version after block' do
      expect(Version.count).to eq(0)
      RequestStore.store[:current_member] = member
      expect(applicant.update(blocked: true))
      expect(Version.count).to eq(1)
    end
  end
end
