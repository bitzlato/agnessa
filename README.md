
# Angessa

[![Ruby](https://github.com/bitzlato/agnessa/actions/workflows/ruby.yml/badge.svg)](https://github.com/bitzlato/agnessa/actions/workflows/ruby.yml)

Legacy(native) kyc user verification service

# Development

Installation:
```bash
bundle install
rails db:setup
```

## Env
- AGNESSA_HOST - host of server
- AGNESSA_DATABASE_NAME - url of postgres
- AGNESSA_REDIS_URL - url for redis
- AGNESSA_SIDEKIQ_AUTH_USER - auth for sidekiq web
- AGNESSA_SIDEKIQ_AUTH_PASSWORD - auth for sidekiq web


## Notification
Content-Type: 'application/json'  

Payload
```json
{ id: 123, status: 'verified'}
// verified, banned, rejected, reseted, pending)
```

## Verification Url Generation

VerificationUrlGenerator.generate_url
```ruby
  url = "http://agnessa.local"
  payload = "123"
  secret = "secret"

  def generate_url(url, payload, secret)
    [url, generate_token(payload, secret)].join('/') # http://agnessa.local/MWE0Y2UwODc2NzJlNTY4MThlZTExNWNiM2I2YzlhMzY6MTIz
  end
 
  def generate_token payload, secret
    digest = Digest::MD5.hexdigest("#{secret}:#{payload}") # 1a4ce087672e56818ee115cb3b6c9a36
    Base64.urlsafe_encode64("#{digest}:#{payload}") # MWE0Y2UwODc2NzJlNTY4MThlZTExNWNiM2I2YzlhMzY6MTIz
  end
```
