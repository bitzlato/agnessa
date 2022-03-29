class Client::ApplicationController < ApplicationController
  private

  def current_client
    RequestStore.store[:current_client]
  end
end