# frozen_string_literal: true

class VerificationStatusNotifyJob
  include Sidekiq::Job

  sidekiq_options queue: :critical, retry: -1

  sidekiq_retry_in do |count|
    60 + rand(60)
  end

  def perform(verification_id)
    verification = Verification.find(verification_id)
    response = VerificationStatusNotifier.perform(verification)
    response.assert_success! if response.present?
  end
end