require 'rails_helper'

RSpec.describe Admin::LogRecordsController, type: :controller do
  let(:account) { create(:account) }
  let(:member) { create(:member, account: account) }
  let(:archived_member) { create(:member, :archived, account: account) }
  before do
    @user = member.user
    login_user
    RequestStore.store[:current_account] = account
  end

  describe 'index' do
    it 'ok' do
      get :index
      expect(response.status).to eq(200)
    end
  end
end