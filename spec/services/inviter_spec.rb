require 'rails_helper'

RSpec.describe Inviter do

  let(:user) { create(:user) }
  let(:inviter) { create(:user) }
  let(:email) { Faker::Internet.email }
  let(:account) { create(:account) }


  it 'raises error when wrong email format' do
    object = Inviter.new(email: 'wrong', account: account, inviter: inviter)
    expect{object.perform!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'handles unregistered user' do
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    result = Inviter
             .new(account: account, email: email, inviter: inviter)
             .perform!

    expect(result).to eq(:invited)
    expect(account.invites.where(email: email).one?).to eq(true)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'add registered user to account ' do
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    expect(user.present?).to eq(true)
    expect(user.members.any?).to eq(false)
    result = Inviter
             .new(account: account, email: user.email, inviter: inviter)
             .perform!

    expect(result).to eq(:membership_created)
    expect(account.users.include?(user)).to eq(true)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end

  it 'do notning if user is registered, and already has access' do
    account.users << user
    result = Inviter
             .new(account: account, email: user.email, inviter: inviter)
             .perform!
    expect(result).to eq(:membership_created)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
end
