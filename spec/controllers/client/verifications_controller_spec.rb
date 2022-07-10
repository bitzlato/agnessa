require 'rails_helper'

RSpec.describe Client::VerificationsController, type: :controller do
  let(:account) { create(:account) }
  before do
    RequestStore.store[:current_account] = account
    allow(ENV).to receive(:fetch).with('AGNESSA_BARONG_API_ROOT_URL').and_return('http://example.com')
    allow(ENV).to receive(:fetch).with('PATH').and_return(ENV['PATH'])
    allow_any_instance_of(BarongClient).to receive(:get_p2pid_from_barong_uid).with('123').and_return(22)
    @request.host = "#{account.subdomain}.example.com"
  end

  describe 'new' do
    it 'opens page with valid encoded_external_id ' do
      get :new, params: {encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret)}
      expect(response.status).to eq(200)
    end

    it 'fails to open page with invalid encoded_external_id ' do
      expect { get :new, params: {encoded_external_id: '123'} }.to raise_exception(VerificationUrlGenerator::WrongPayload)
    end
  end

  describe 'create' do
    let(:country) { create(:country)}
    let(:applicant) { create(:applicant, account: account) }
    let(:verification) do
      build(:verification,
            applicant: applicant,
            citizenship_country: country)
    end
    let(:params) do
      {
        encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret),
        verification: verification.attributes.merge(
          verification_documents_attributes: verification.verification_documents.map do |doc|
            doc.attributes.merge(
              file: fixture_file_upload(File.join(Rails.root, '/spec/fixtures/image.jpg'), 'image/jpeg')
            )
          end
        )
      }
    end
    it 'success' do
      post :create, params: params
      expect(response.status).to eq(200)
      expect(Verification.last.status).to eq('pending')
    end
  end
end
