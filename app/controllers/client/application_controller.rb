class Client::ApplicationController < ApplicationController
  helper_method :current_client

  private

  def current_client
    RequestStore.store[:current_client]
  end
end
