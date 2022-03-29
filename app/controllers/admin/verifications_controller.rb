class Admin::VerificationsController < Admin::ResourcesController

  def show
    render locals: { verification: verification }
  end

  def update
    render locals: { verification: verification }
  end

  def confirm
    verification.confirm!(user: current_user)
    redirect_to admin_verification_path(verification), notice: 'Подтверждено'
  end

  def refuse
    verification.refuse!(user: current_user,
                        labels: verification_params[:review_result_labels],
                        user_comment: verification_params[:user_comment],
                        moderator_comment: verification_params[:moderator_comment])
    redirect_to admin_verification_path(verification), notice: 'Отвергнуто'
  end

  private

  def verification
    @verification ||= Verification.find(params[:id])
  end

  def verification_params
    params.require(:verification).permit( :user_comment, :moderator_comment, :review_result_labels => [])
  end
end
