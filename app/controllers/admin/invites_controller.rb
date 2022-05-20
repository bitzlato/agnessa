class Admin::InvitesController < Admin::ApplicationController
  def destroy
    invite = current_account.invites.find(params[:id])
    invite.destroy!
    redirect_back(fallback_location: admin_members_path)
  end
end
