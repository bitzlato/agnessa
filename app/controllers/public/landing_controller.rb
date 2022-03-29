class Public::LandingController < Public::ApplicationController
  layout 'simple'

  def index
    render locals: { clients: Account.all }
  end
end
