require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:image_document) { create(:verification_document, :image) }
  let(:video_document) { create(:verification_document, :video) }

  describe :create do
    it 'success create image verification document' do
    end
  end
end
