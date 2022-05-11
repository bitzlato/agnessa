class Legacy::VerificationsController < ApplicationController
  layout 'legacy'

  def index
    account = Account.find_by_subdomain!('bz')
    result = {}
      account.verifications.includes(:applicant).for_export.order('verifications.created_at ASC').each do |v|
        next if v.applicant.legacy_external_id.nil?

        cleared_id = v.applicant.legacy_external_id.gsub('id_', '')
        id = "id_#{cleared_id}"
        time = v.updated_at.to_i * 1000

        result[id] = {
          id: id,
          status: v.status.to_s == 'confirmed' ? true : false,
          comment: v.public_comment.to_s.strip,
          time: time
        }
    end

    render json: result.values.sort_by{|v| v[:time]}.reverse
  end

  def legacy_show
    respond_to do |format|
      format.html
    end
  rescue ActionController::UnknownFormat
    render(inline: 'Not Found', status: :unsupported_media_type)
  end

  def show
    account = Account.find_by_subdomain('bz')
    uid = BarongClient.instance.get_barong_uid_from_changebot_id(change_bot_id)
    if uid.present? and account.present?
      encoded_external_id = VerificationUrlGenerator.generate_token(uid, account.secret)
      url_options = Rails.configuration.application.default_url_options.symbolize_keys
      url_options[:subdomain] = account.subdomain
      redirect_to new_client_verification_url(encoded_external_id, url_options)
    else
      Bugsnag.notify(StandardError.new("Unknown Changebot Id: #{params[:id]}"))
      raise HumanizedError, :invalid_barong_uid
    end
  end

  def legacy_root
    redirect_to public_root_url(host: ENV.fetch('AGNESSA_HOST'))
  end

  def change_bot_id
    id = params[:id]
    id = id.gsub('id', '').gsub('_', '').gsub('\\', '')
    "id_#{id}"
  end
end