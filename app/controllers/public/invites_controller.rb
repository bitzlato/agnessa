class Public::InvitesController < Public::ApplicationController
  def accept
    raise HumanizedError, :cant_accept_logout if logged_in?

    invite = Invite.find_by! token: params[:id]

    auto_login InviteAcceptor.new(invite).accept!

    flash_notice! :invite_accepted
    redirect_to admin_account_url(subdomain: invite.account.subdomain)
  rescue ActiveRecord::RecordNotFound
    raise HumanizedError, :link_expired
  end
end
