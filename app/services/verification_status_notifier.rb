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
    url = verification.client.verification_callback_url
    data = {id: verification.applicant.external_id, status: STATUS_MAPPING[verification.status]}
    notifier = self.new(url, data)
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