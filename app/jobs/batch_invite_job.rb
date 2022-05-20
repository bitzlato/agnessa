# frozen_string_literal: true

class BatchInviteJob < ApplicationJob

  attr_reader :account, :inviter

  def perform(account_id:, inviter_id:, emails:)
    @account = Account.find account_id
    @inviter = User.find inviter_id

    emails.each do |email|
      make_invite email
    end
  end

  private

  def make_invite(email)
    result = Inviter
             .new(account: account, inviter: inviter, email: email)
             .perform!
    logger.info "Made invite for '#{account.name}', email=#{email}, result=#{result}"
  rescue StandardError => e
    logger.error "Error: Made invite for '#{account.name}', email=#{email}, err=#{e}"
    Bugsnag.notify(e)
  end
  # rubocop:enable Metrics/AbcSize
end
