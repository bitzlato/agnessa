class Agnessa::JWT
  IAT_LEEWAY = [30.seconds, 5.seconds]

  def self.decode_and_verify!(token, jwk)
    keypair = JWT::JWK.import(jwk).keypair
    payload, header = ::JWT.decode(
      token,
      keypair,
      true,       # Verify the signature of this token
      algorithms: 'ES256',
      # aud:        ['mob'],
      verify_iat: true,
      # verify_aud: true,
      # required_claims: ['uid'],
    )
    iat = payload['iat']
    unless Time.at(iat).between?(nbf, exp)
      Rails.logger.debug("authz.invalid_jwt_token: iat=#{iat} is not beetween #{nbf.to_i} and #{exp.to_i}")
      return nil
    end
    payload
  rescue JWT::DecodeError => e
    Rails.logger.debug("authz.invalid_jwt_token (#{e.message}) #{token}")
    raise e
  end

  def self.nbf
    Time.current - IAT_LEEWAY[0]
  end

  def self.exp
    Time.current + IAT_LEEWAY[1]
  end
end