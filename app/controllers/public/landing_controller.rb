class Public::LandingController < Public::ApplicationController
  layout 'simple'

  def index
    render locals: { clients: Client.all }
  end
end
