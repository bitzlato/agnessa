# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_public_password_reset_url(@user.reset_password_token)
    mail to: @user.email
  end

  def invite(invite_id)
    @invite = Invite.find invite_id
    @inviter = @invite.inviter
    @url = accept_public_invite_url(@invite.token)
    @brand = admin_root_url(subdomain: @invite.account.subdomain)

    mail to: @invite.email
  end
end
