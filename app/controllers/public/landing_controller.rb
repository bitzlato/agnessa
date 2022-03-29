class Public::LandingController < Public::ApplicationController
  layout 'simple'

  def index
    render locals: { account: Account.all }
  end
end
