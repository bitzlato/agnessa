class Admin::ClientUsersController < Admin::ApplicationController
  before_action :superadmin?

  def index
    client_users = current_client.client_users
    render locals: {client_users: client_users}
  end

  def show
    render locals: {client_user: client_user}
  end

  def new
    client_user = current_client.client_users.new
    render locals: {client_user: client_user}
  end

  def edit
    render locals: {client_user: client_user}
  end

  def create
    client_user = current.client.client_users.create!(admin_user_params)
    redirect_to admin_client_user_url(client_user), notice: "Client user was successfully created."
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? ClientUser
    render :new, locals: {client_user: client_user}
  end

  def update
    client_user.update!(admin_user_params)
    redirect_to admin_client_user_url(client_user), notice: "Admin user was successfully updated."
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? ClientUser
    render :edit, locals: {client_user: client_user}
  end

  def destroy
    client_user.destroy!
    redirect_to admin_client_users_url, notice: "Admin user was successfully destroyed."
  end

  private

  def client_user
    @client_user ||= current_client.client_users.find(params[:id])
  end

  def admin_user_params
    params.require(:client_user).permit(:login, :password, :password_confirmation, :role)
  end
end
