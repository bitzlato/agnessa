require 'rails_helper'

RSpec.describe Client::VerificationsController, type: :controller do
  let(:client) { create(:client) }
  before do
    RequestStore.store[:current_client] = client
  end

  describe 'new' do
    it 'opens page with valid encoded_external_id ' do
      @request.host = "#{client.subdomain}.example.com"
      get :new, params: {encoded_external_id: VerificationUrlGenerator.generate_token('123', client.secret)}
      expect(response.status).to eq(200)
    end

    it 'fails to open page with invalid encoded_external_id ' do
      @request.host = "#{client.subdomain}.example.com"
      expect { get :new, params: {encoded_external_id: '123'} }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end