class Admin::ApplicationController < ActionController::Base
  layout 'admin'
  before_action :basic_auth

  private

  def basic_auth
    unless current_user
      authenticate_or_request_with_http_basic do |login, password|
        user = current_client.client_users.find_by_login(login)&.authenticate(password)
        if user
          session[:current_user] = user.id
          true
        else
          false
        end
      end
    end
  end

  def superadmin?
    redirect_to admin_moderation_index_path unless current_user.superadmin?
  end

  def current_client
    RequestStore.store[:current_client]
  end

  def current_user
    ClientUser.find_by(id: session.dig(:current_user))
  end

  def per_page
    params[:per]
  end

  def page
    params[:page]
  end
end
