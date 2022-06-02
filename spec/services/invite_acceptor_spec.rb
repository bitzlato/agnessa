require 'rails_helper'

RSpec.describe InviteAcceptor do
  it 'handles invite accept' do
    invite = create(:invite)
    user = InviteAcceptor
             .new(invite)
             .accept!

    expect(user.present?).to eq(true)
    expect(invite.account.members.last.inviter).to eq(invite.inviter)
    expect(user.email).to eq(invite.email)
  end
end
