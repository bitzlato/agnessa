# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('AGNESSA_REDIS_URL', 'redis://localhost:6379/0'), namespace: "agnessa_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('AGNESSA_REDIS_URL', 'redis://localhost:6379/0'), namespace: "agnessa_#{Rails.env}" }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV.fetch('AGNESSA_SIDEKIQ_AUTH_USER', 'agnessa'), ENV.fetch('AGNESSA_SIDEKIQ_AUTH_PASSWORD', 'password')]
end

module Sidekiq
  class JobRetry
    # infinity retry attempts monkeypatch
    def retry_attempts_from(msg_retry, default)
      value = if msg_retry.is_a?(Integer)
        msg_retry
      else
        default
      end
      value == -1 ? Float::INFINITY : value
    end
  end
end