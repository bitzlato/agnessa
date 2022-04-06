require 'rails_helper'

RSpec.describe Client::VerificationsController, :type => :request do
  let(:account) { create(:account) }
  let(:external_id) { VerificationUrlGenerator.generate_token('123', account.secret) }

  describe 'new' do
    it 'opens page with correct domain' do
      host!"#{account.subdomain}.localhost"
      get new_client_verification_path(encoded_external_id: external_id)
      expect(response.status).to eq(200)
    end

    it 'opens page by short url' do
      host!"#{account.subdomain}.localhost"
      get client_short_new_verification_path(external_id)
      expect(response.status).to eq(200)
    end

    it 'fails to open page with incorrect domain' do
      get new_client_verification_path(encoded_external_id: external_id)
      expect(response.status).to eq(404)
    end
  end
end