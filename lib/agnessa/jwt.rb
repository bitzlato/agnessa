class Agnessa::JWT
  NBF_LEEWAY = 30.seconds
  EXP_LEEWAY = 5.seconds

  def self.decode_and_verify!(token, jwk)
    keypair = JWT::JWK.import(jwk).keypair
    payload, header = ::JWT.decode(
      token,
      keypair,
      true,       # Verify the signature of this token
      algorithms: 'ES256',
      verify_iat: true,
      # aud:        ['mob'],
      # verify_aud: true,
      # required_claims: ['uid'],
      nbf_leeway: NBF_LEEWAY,
      exp_leeway: EXP_LEEWAY
    )
    payload
  rescue JWT::DecodeError => e
    Rails.logger.debug("authz.invalid_jwt_token (#{e.message}) #{token}")
    raise e
  end
end