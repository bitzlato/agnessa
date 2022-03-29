require 'rails_helper'

RSpec.describe VerificationUrlGenerator do
  let(:string_payload) { "123" }
  let(:json_payload_string) { '{user: "22"}' }
  let(:secret) { 'sercret' }
  let(:plain_token) { "NzQzZDk5ODgzOGJhNzhjMmU4MGJmNWFmODA4YWY4ODA6MTIz" }
  let(:json_token) { "YTFkYzUxNmQwMzE2NDY5MDAyOWFkZDc4YWY5Y2E0ZGE6e3VzZXI6ICIyMiJ9" }


  describe 'generate_token' do
    it 'generated token for plain string' do
      result = VerificationUrlGenerator.generate_token(string_payload, secret)
      expect(result).to eq(plain_token)
    end

    it 'generated token for plain string' do
      result = VerificationUrlGenerator.generate_token(json_payload_string, secret)
      expect(result).to eq(json_token)
    end
  end

  describe 'payload_from_token' do
    it 'parses string token' do
      result = VerificationUrlGenerator.payload_from_token(plain_token, secret)
      expect(result).to eq(string_payload)
    end

    it 'parses json token' do
      result = VerificationUrlGenerator.payload_from_token(json_token, secret)
      expect(result).to eq(json_payload_string)
    end
  end
end