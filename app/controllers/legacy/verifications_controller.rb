class Legacy::VerificationsController < ApplicationController
  layout 'legacy'

  def index
    account = Account.find_by_subdomain!('bz')
    result = {}
    account.verifications.all.order('created_at ASC').each do |v|
      id = v.legacy_external_id || v.applicant.legacy_external_id
      if id.present?
        result[id] = {
          id: id,
          status: v.status.to_s == 'confirmed' ? true : false,
          comment: v.external_json['comment'].to_s,
          time: v.legacy_created || (v.created_at.to_i * 1000)
        }
      end
    end

    render json: result.values
  end

  def legacy_show
    render locals: {}
  end

  def show
    account = Account.find_by_subdomain('bz')
    if account.present?
      encoded_external_id = VerificationUrlGenerator.generate_token(params[:id], account.secret)
      url_options = Rails.configuration.application.default_url_options.symbolize_keys
      url_options[:subdomain] = account.subdomain
      redirect_to new_client_verification_url(encoded_external_id, url_options)
    else
      render :error
    end
  end
end