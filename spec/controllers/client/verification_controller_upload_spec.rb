require 'rails_helper'

RSpec.describe Client::VerificationsController, type: :controller do
  let(:account) { create(:account) }
  let(:verification_sample) { build(:verification)}

  describe 'verification_documents' do

    before do
      RequestStore.store[:current_account] = account
      allow_any_instance_of(BarongClient).to receive(:get_p2pid_from_barong_uid).with('123').and_return(22)
      @request.host = "#{account.subdomain}.example.com"
    end

    it 'success upload with documents' do
      params = {
        encoded_external_id: VerificationUrlGenerator.generate_token('123', account.secret),
        verification: {
          name: verification_sample.name,
          applicant_comment: verification_sample.applicant_comment,
          reason: verification_sample.reason,
          country: verification_sample.country,
          birth_date: verification_sample.birth_date,
          gender: verification_sample.gender,
          last_name: verification_sample.last_name,
          patronymic: verification_sample.patronymic,
          email: verification_sample.email,
          document_number: verification_sample.document_number
        }
      }
      get :create, params: params
      expect(response.status).to eq(200)

    end

  end
end
