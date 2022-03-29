class VerificationStatusNotifier
  STATUS_MAPPING = {
    # banned, reseted, pending
    'refused': :rejected,
    'confirmed': :verified
  }

  OPEN_TIMEOUT = 10 # opening connection timeout in seconds
  TIMEOUT = 300 # waiting for response timeout in seconds

  attr_accessor :url, :data

  def self.perform verification
    notifier = self.new(url, {id: verification.legacy_verification_id, status: STATUS_MAPPING[verification.status]})
    notifier.perform
  end

  def initialize url, data
    @url = url
    @data = data
  end

  def perform
    client.post('/') do |req|
      req.body = data.to_json
      req.headers['Content-Type'] = 'application/json'
    end
  end

  private

  def client
    Faraday.new(url) do |conn|
      conn.adapter Faraday.default_adapter
      conn.options.open_timeout = OPEN_TIMEOUT
      conn.options.timeout = TIMEOUT
    end
  end
end