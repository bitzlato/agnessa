class VerificationStatusNotifier
  OPEN_TIMEOUT = 10 # opening connection timeout in seconds
  TIMEOUT = 300 # waiting for response timeout in seconds

  attr_accessor :url, :data

  def self.perform verification
    url = verification.account.verification_callback_url
    data = {
      external_id: verification.applicant.external_id,
      verification_id: verification.id,
      status: verification.status,
      reason: verification.public_comment,
      time: verification.updated_at.to_s(:iso8601),
      # applicant_id: verification.applicant.id,
      # email: verification.email,
    }
    notifier = self.new(url, data)
    notifier.perform
  end

  def initialize url, data
    @url = url
    @data = data
  end

  def perform
    if url.present?
      send_request
    else
      Rails.logger.error("Не задан урл отправки получений уведомлени для payload '#{data}'")
      nil
    end
  end

  private

  def send_request
    client.post(url) do |req|
      req.body = data.to_json
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def client
    Faraday.new do |conn|
      conn.adapter Faraday.default_adapter
      conn.options.open_timeout = OPEN_TIMEOUT
      conn.options.timeout = TIMEOUT
    end
  end
end