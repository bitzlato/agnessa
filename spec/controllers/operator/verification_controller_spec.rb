require 'rails_helper'

RSpec.describe Operator::VerificationsController, type: :controller do
  let(:account) { create(:account) }
  before do
    RequestStore.store[:current_account] = account
    allow(ENV).to receive(:fetch).with('AGNESSA_BARONG_API_ROOT_URL').and_return('http://example.com')
    allow_any_instance_of(BarongClient).to receive(:get_p2pid_from_barong_uid).with('123').and_return(22)
  end

  describe 'new' do
    it 'opens page' do
      @request.host = "#{account.subdomain}.example.com"
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'create' do
    it 'external_id exist' do
      @request.host = "#{account.subdomain}.example.com"
      post :create, params: {verification: {external_id: '123'}}
      expect(response.status).to eq(302)
    end
  end
end
