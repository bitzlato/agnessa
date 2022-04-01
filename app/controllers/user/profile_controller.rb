class User::ProfileController < User::ApplicationController
  def show
    render locals: {user: current_user}
  end

  def update
    current_user.update!(user_params)
    redirect_to profile_path
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? User
    render :show, locals: {user: current_user}
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name)
  end
end