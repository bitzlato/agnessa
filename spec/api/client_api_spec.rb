require 'rails_helper'

RSpec.describe ClientApi, :type => :request do
  let(:key) { OpenSSL::PKey::EC.new('prime256v1').tap(&:generate_key) }
  let(:kid) { 1 }
  let(:json_public_key) { JWT::JWK.new(key, kid: kid).export }
  let(:account) { create(:account, api_jwk: json_public_key) }
  let(:payload) { {iat: Time.current.to_i, jti: SecureRandom.hex(4), aud: :tet, exp: 5.minutes.since.to_i, uid: 1} }

  let(:applicant) { create(:applicant, account: account) }
  let(:token) { JWT.encode(payload, key, 'ES256', kid: kid) }

  describe 'users' do
    it 'returns usr information' do
      host!"#{account.subdomain}.localhost"
      get "/api/users/#{applicant.external_id}", headers: {Authorization: "GWT #{token}"}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).keys).to eq(%w(first_name last_name emails confirmed_at))
    end
  end
end