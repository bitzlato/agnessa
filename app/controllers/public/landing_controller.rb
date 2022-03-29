class Public::LandingController < Public::ApplicationController
  def index
    render locals: { clients: Client.all }
  end
end
