class Public::LandingController < Public::ApplicationController
  layout 'simple'

  def index
    render locals: { accounts: Account.all }
  end
end
