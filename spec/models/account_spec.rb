require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account) }

  it "has 3 document types after creation" do
    expect(account.document_types.count).to eq(3)
  end
end
