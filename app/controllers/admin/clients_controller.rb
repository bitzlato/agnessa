class Admin::ClientsController < Admin::ApplicationController

  def show
    render locals: {client: current_client}
  end

  def update
    current_client.update!(client_params)
    redirect_to admin_client_url(subdomain: current_client.subdomain)
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Client
    render :show, locals: {client: current_client}
  end

  def verification_callback_test
    begin
      notifier = VerificationStatusNotifier.new(current_client.verification_callback_url, params[:data])
      response = notifier.perform
      status = response.status
      body = response.body
    rescue Faraday::ConnectionFailed
      status = nil
      body = 'ConnectionFailed'
    end

    render locals: {status: status, body: body}, layout: false
  end

  def recreate_secret
    current_client.recreate_secret!
    redirect_to admin_client_path
  end

  private

  def client_params
    params.require(:client).permit(:subdomain, :verification_callback_url)
  end
end