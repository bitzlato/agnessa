require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:verification_document) { create(:verification_document)}


  describe :create do
    it 'success create verification document' do
      expect(verification_document.id).to be_truthy
    end
  end
end
