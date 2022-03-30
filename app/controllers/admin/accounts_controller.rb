class Admin::AccountsController < Admin::ApplicationController

  def show
    render locals: {account: current_account}
  end

  def update
    current_account.update!(account_params)
    redirect_to admin_account_url(subdomain: current_account.subdomain)
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Account
    render :show, locals: {account: current_account}
  end

  def verification_callback_test
    begin
      notifier = VerificationStatusNotifier.new(current_account.verification_callback_url, params[:data])
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
    current_account.recreate_secret!
    redirect_to admin_account_path
  end

  private

  def account_params
    params.require(:account).permit(:subdomain, :verification_callback_url, :email_from)
  end
end