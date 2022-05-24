require 'rails_helper'

RSpec.describe Client::VerificationsController, :type => :request do
  let(:account) { create(:account) }
  let(:external_id) { VerificationUrlGenerator.generate_token('id_123', account.secret) }

  before do
    allow(ENV).to receive(:fetch).with('AGNESSA_BARONG_API_ROOT_URL').and_return('http://example.com')
    allow(ENV).to receive(:fetch).with('AGNESSA_LEGACY_VERIFICATION_HOST').and_return('http://old.example.com')

    allow_any_instance_of(BarongClient).to receive(:get_p2pid_from_barong_uid).with('id_123').and_return(22)
  end

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

    # it 'fails to open page with incorrect domain' do
    #   host! "unknown.localhost"
    #   get new_client_verification_path(encoded_external_id: external_id)
    #   expect(response.status).to eq(404)
    # end
  end
end