class Legacy::VerificationsController < ApplicationController
  layout 'legacy'

  def legacy_show
    render locals: {}
  end

  def show
    uid = BarongClient.new.get_uid_from_changebot_id(params[:id])
    account = Account.first
    if uid.present? and account.present?
      encoded_external_id = VerificationUrlGenerator.generate_token(uid, account.secret)
      url_options = Rails.configuration.application.default_url_options.symbolize_keys
      url_options[:subdomain] = account.subdomain
      redirect_to new_client_verification_url(encoded_external_id, url_options)
    else
      Bugsnag.notify(StandardError.new("Unknown Changebot Id: #{params[:id]}"))
      render :error
    end
  end
end