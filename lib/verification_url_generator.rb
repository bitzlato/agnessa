class VerificationUrlGenerator
  WrongPayload = Class.new StandardError

  class << self
    def generate_url(url, payload, secret)
      [url, generate_token(payload, secret)].join('/')
    end

    def generate_token payload, secret
      digest = Digest::MD5.hexdigest("#{secret}:#{payload}")
      Base64.urlsafe_encode64("#{digest}:#{payload}")
    end

    def payload_from_token(token, secret)
      values = Base64.urlsafe_decode64(token).split(":")
      digest = values.shift
      payload = values.is_a?(Array) ? values.join(":") : values

      original_digest = Digest::MD5.hexdigest("#{secret}:#{payload}")
      payload if original_digest == digest
    rescue StandardError => err
      Rails.logger.error err
      raise WrongPayload
    end
  end
end
