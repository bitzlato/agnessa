class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  default  Rails.configuration.application.mailer_defaults.symbolize_keys
end

