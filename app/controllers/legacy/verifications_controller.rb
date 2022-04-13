class Legacy::VerificationsController < ApplicationController
  layout 'legacy'

  def index
    account = Account.find_by_subdomain!('bz')
    verifications = account.verifications.
      all.
      order('created_at DESC').
      map do |v|
      {
        id: v.legacy_external_id,
        status: v.status.to_s == 'confirmed' ? true : false,
        comment: v.external_json['comment'],
        time: v.legacy_created || (v.created_at.to_i * 1000)
      }
    end

    render json: verifications
  end

  def legacy_show
    render locals: {}
  end

  def show
    uid = BarongClient.instance.get_uid_from_changebot_id(params[:id])
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