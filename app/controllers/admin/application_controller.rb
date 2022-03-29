class Admin::ApplicationController < ApplicationController
  before_action :basic_auth

  helper_method :current_user

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

  def current_client
    RequestStore.store[:current_client]
  end

  def current_user
    ClientUser.find_by(id: session.dig(:current_user))
  end
end
