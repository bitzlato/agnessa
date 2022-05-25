require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:image_document) { create(:verification_document, :image) }
  let(:video_document) { create(:verification_document, :video) }

  describe :create do
    it 'success create video verification document' do
      expect(video_document.id).to be_truthy
    end
    it 'success create image verification document' do
      expect(image_document.id).to be_truthy
    end
  end
end
