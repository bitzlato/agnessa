require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account) }

  describe :create do
    it '3 DocumentType after create' do
      document_types = account.document_types
      expect(document_types.count).to eq(3)
    end
  end

end
