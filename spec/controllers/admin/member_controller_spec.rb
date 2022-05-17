require 'rails_helper'

RSpec.describe Admin::MembersController, type: :controller do
  let(:account) { create(:account) }
  let(:member) { create(:member, :admin, account: account) }
  let(:archived_member) { create(:member, :archived, account: account) }
  before do
    @user = member.user
    login_user
    RequestStore.store[:current_account] = account
  end

  describe 'archive' do
    it 'success archive' do
      delete :archive, params: {id: member.id}
      expect(member.reload.archived?).to be_truthy
    end
  end

  describe 'restore' do
    it 'success restore' do
      post :restore, params: {id: archived_member.id}
      expect(archived_member.reload.archived?).to be_falsey
    end
  end
end
