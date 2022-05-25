require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:verification_document) { create(:verification_document)}


  describe :create do
    it 'archived' do
      expect(verification_document).to be_truthy
    end
  end
end
