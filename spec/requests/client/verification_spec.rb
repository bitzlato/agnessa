require 'rails_helper'

RSpec.describe Client::VerificationsController, :type => :request do
  let(:client) { create(:client) }

  describe 'new' do
    it 'opens page with correct domain' do
      host!"#{client.subdomain}.example.com"
      get new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('123', client.secret))
      expect(response.status).to eq(200)
    end

    it 'fails to open page with incorrect domain' do
      request = lambda { get new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token('123', client.secret)) }
      expect(request).to raise_error(ActionController::RoutingError)
    end
  end
end