class Admin::ApplicationController < ApplicationController
  include UserAuthSupport
  before_action :authorize_user

  layout 'fluid'

  helper_method :current_account


  def current_account
    RequestStore.store[:current_account]
  end

  private

  def authorize_user
    raise 'unauthorized user' unless current_user and current_account.users.include?(current_user)
  end
end
