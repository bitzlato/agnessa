# frozen_string_literal: true

class Public::SessionsController < Public::ApplicationController
  layout 'simple'
  skip_before_action :verify_authenticity_token, only: [:destroy]

  def new
    render locals: { user_session: UserSession.new, message: nil }
  end

  def create
    if login(user_session.email, user_session.password, true)
      redirect_to public_root_url, success: t('flashes.welcome', name: current_user.email)
    else
      render :new, locals: { user_session: user_session, message: t('flashes.wrong_credentials') }
    end
  end

  def destroy
    logout
    redirect_to public_root_url, notice: t('flashes.logout')
  end

  private

  def user_session
    @user_session ||= UserSession.new params[:user_session].permit(:email, :password, :remember_me)
  end
end
