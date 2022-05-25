class Admin::MembersController < Admin::ApplicationController
  before_action :authorize_admin

  def index
    members = paginate current_account.members.order('archived_at desc')
    form = InviteForm.new
    invited = current_account.invites.ordered
    render locals: {members: members, form: form, invited: invited}
  end

  def create
    if form.valid?
      make_invites
      flash_notice! :invited, count: form.emails_list.count
      redirect_to admin_members_url
    else
      members = paginate current_account.members.order('archived_at desc')
      render :index, locals: {members: members, form: form, invited: current_account.invites.ordered }
    end
  end

  def update
    member.update!(admin_user_params)
    redirect_back fallback_location: admin_members_url, notice: 'Member was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Member
    render :edit, locals: {member: member}
  end

  def restore
    member.restore!
    redirect_back fallback_location: admin_members_url, notice: 'Member was successfully restored.'
  end

  def archive
    member.archive!
    redirect_back fallback_location: admin_members_url, notice: 'Member was successfully archived.'
  end

  private

  def form
    @form ||= InviteForm.new params.require(:invite_form).permit(:emails)
  end

  def make_invites
    BatchInviteJob.perform_later(
      account_id: current_account.id,
      inviter_id: current_user.id,
      emails: form.emails_list
    )
  end

  def member
    @member ||= current_account.members.find(params[:id])
  end

  def admin_user_params
    params.require(:member).permit(:role)
  end
end
