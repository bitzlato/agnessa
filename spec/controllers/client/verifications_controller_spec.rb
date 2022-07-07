require 'rails_helper'

RSpec.describe Client::VerificationsController, type: :controller do
  let(:account) { create(:account) }
  before do
    RequestStore.store[:current_account] = account
    allow(ENV).to receive(:fetch).with('AGNESSA_BARONG_API_ROOT_URL').and_return('http://example.com')
    allow_any_instance_of(BarongClient).to receive(:get_p2pid_from_barong_uid).with('123').and_return(22)
  end

  describe 'new' do
    it 'opens page with valid encoded_external_id ' do
      @request.host = "#{account.subdomain}.example.com"
      get :new, params: {encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret)}
      expect(response.status).to eq(200)
    end

    it 'fails to open page with invalid encoded_external_id ' do
      @request.host = "#{account.subdomain}.example.com"
      expect { get :new, params: {encoded_external_id: '123'} }.to raise_exception(VerificationUrlGenerator::WrongPayload)
    end
  end

  describe 'create' do
    let(:country) { create(:country)}
    let(:verification) { build(:verification, account: account, citizenship_country: country) }
    it 'success create' do
      @request.host = "#{account.subdomain}.example.com"
      params = {
        encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret),
        verification: {
          name: verification.name,
          next_step: 5,
          document_type: verification.document_type,
          citizenship_country_iso_code: verification.citizenship_country_iso_code,
          birth_date: verification.birth_date,
          last_name: verification.last_name,
          patronymic: verification.patronymic,
          email: verification.email,
          document_number: verification.document_number,
          verification_documents_attributes:
            account.document_types.alive.each_with_index{ |x, index| {index.to_s => {document_type_id: x.id, file: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), 'image/jpeg')}}  }
        }
      }
      post :create, params: params
      expect(response.status).to eq(200)
    end
  end
end
