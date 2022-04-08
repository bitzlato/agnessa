class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: Rails.configuration.application.mailer_defaults.symbolize_keys[:from]
end