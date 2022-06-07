require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { create(:country, :full_types)}

  describe :create do
    it 'success' do
      expect(country.id).to be_truthy
    end
  end
end
