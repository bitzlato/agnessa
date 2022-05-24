require 'rails_helper'

RSpec.describe DocumentType, type: :model do

  describe :create do
    it 'just create' do
      document_type = create(:document_type)
      expect(DocumentType.count).to eq(1)
    end
  end
end
