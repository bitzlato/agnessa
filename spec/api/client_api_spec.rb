require 'rails_helper'

RSpec.describe ClientApi, :type => :request do
  let(:key) { OpenSSL::PKey::EC.new('prime256v1').tap(&:generate_key) }
  let(:kid) { 1 }
  let(:json_public_key) { JWT::JWK.new(key, kid: kid).export }
  let(:account) { create(:account, api_jwt_public_key: json_public_key, api_jwt_algorithm: 'ES256') }
  let(:payload) { {iat: Time.current.to_i, jti: SecureRandom.hex(4), aud: :tet, exp: 5.minutes.since.to_i, uid: 1} }

  let(:applicant) { create(:applicant, account: account) }
  let(:token) { JWT.encode(payload, key, account.api_jwt_algorithm, kid: kid) }

  before do
    RequestStore.store[:current_account] = account
  end

  describe 'applicants' do
    it 'returns usr information' do
      host!"#{account.subdomain}.localhost"
      get "/api/v1/applicants/#{applicant.external_id}", headers: {Authorization: "GWT #{token}"}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).keys).to eq(%w(first_name last_name patronymic emails confirmed_at))
    end
  end
end