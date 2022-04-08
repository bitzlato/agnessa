class User::AccountsController < User::ApplicationController
  def index
    render locals: {user: current_user}
  end
end