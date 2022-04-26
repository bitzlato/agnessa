require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }

  describe :archive do
    it 'archived' do
      member.archive!
      expect(member.archived_at).to be_truthy
    end
  end

end
