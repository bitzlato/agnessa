class Admin::ApplicationController < ApplicationController
  layout 'fluid'

  before_action :basic_auth

  helper_method :current_member
  helper_method :current_account

  private

  def basic_auth
    unless current_member
      authenticate_or_request_with_http_basic do |login, password|
        user = current_account.members.find_by_login(login)&.authenticate(password)
        if user
          session[:current_member] = user.id
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

  def current_member
    member = Member.find_by(id: session.dig(:current_member))
    RequestStore.store[:current_member] = member
    member
  end
end
