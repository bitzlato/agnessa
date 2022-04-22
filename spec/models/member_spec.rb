require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }

  describe :destroy do
    it 'archived' do
      member.destroy
      expect(member.archive).to be_truthy
    end
  end

end
