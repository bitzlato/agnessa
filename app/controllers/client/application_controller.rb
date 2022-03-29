class Client::ApplicationController < ApplicationController
  helper_method :current_account

  private

  def current_account
    RequestStore.store[:current_account]
  end
end
