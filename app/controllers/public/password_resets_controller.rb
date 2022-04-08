# frozen_string_literal: true

class Public::PasswordResetsController < Public::ApplicationController
  layout 'simple'

  before_action :require_user, except: %i[new create]

  def new
    render locals: { form: form }
  end

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    if form.valid?
      deliver_instruction form.email
      render
    else
      render :new, locals: { form: form }
    end
  end

  # This is the reset password form.
  def edit
    render locals: { token: token, user: user }
  end

  # rubocop:disable Metrics/AbcSize
  # This action fires when the user has sent the reset password form.
  def update
    # the next line makes the password confirmation validation work
    user.password_confirmation = permitted_params[:password_confirmation]
    # the next line clears the temporary token and updates the password
    if user.change_password permitted_params[:password]
      auto_login user
      redirect_to public_root_path, notice: t_flash
    else
      render :edit, locals: { user: user, token: token }
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def permitted_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def deliver_instruction(email)
    user = User.find_by email: email

    if user.present?
      user.deliver_reset_password_instructions!
    else
      Rails.logger.error "No user found (#{email}) to restore"
    end
  end

  def require_user
    return if user.present?
    flash_alert! :link_expired
    render :new, locals: { form: PasswordReset.new }
  end

  def token
    params[:id]
  end

  def user
    return @user if instance_variable_defined? :@user

    @user = UserWithPassword.load_from_reset_password_token token
  end

  def form
    @form ||= PasswordReset.new params.fetch(:password_reset, {}).permit(:email)
  end
end
