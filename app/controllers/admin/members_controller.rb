class Admin::MembersController < Admin::ApplicationController
  # before_action :superadmin?

  def index
    members = paginate current_account.members.order('archived_at desc')
    render locals: {members: members}
  end

  def show
    render locals: {member: member}
  end

  def new
    member = current_account.members.new
    render locals: {member: member}
  end

  def edit
    render locals: {member: member}
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

  def member
    @member ||= current_account.members.find(params[:id])
  end

  def admin_user_params
    params.require(:member).permit(:role)
  end
end
