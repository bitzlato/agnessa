require 'rails_helper'

RSpec.describe VerificationStatusNotifier do
  let(:client) { create(:client, verification_callback_url: 'http://test.test.test') }
  let(:verification) { create(:verification, client: client)}

  it "sends verification data" do
    stub_request(:post, "http://test.test.test/").to_return(status: 200, body: "")
    VerificationStatusNotifier.perform(verification)
  end
end
