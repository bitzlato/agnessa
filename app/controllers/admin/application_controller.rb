class Admin::ApplicationController < ApplicationController
  layout 'fluid'

  before_action :basic_auth

  helper_method :current_user
  helper_method :current_account

  private

  def basic_auth
    unless current_user
      authenticate_or_request_with_http_basic do |login, password|
        user = current_account.members.find_by_login(login)&.authenticate(password)
        if user
          session[:current_user] = user.id
          true
        else
          false
        end
      end
    end
  end

  def current_account
    RequestStore.store[:current_account]
  end

  def current_user
    Member.find_by(id: session.dig(:current_user))
  end
end
