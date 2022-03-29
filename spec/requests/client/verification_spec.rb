require 'rails_helper'

RSpec.describe Client::VerificationsController, :type => :request do
  let(:account) { create(:account) }

  describe 'new' do
    it 'opens page with correct domain' do
      host!"#{account.subdomain}.example.com"
      get new_client_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret))
      expect(response.status).to eq(200)
    end

    it 'fails to open page with incorrect domain' do
      get new_client_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret))
      expect(response.body).to include('404')
    end
  end
end