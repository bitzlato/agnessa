class Admin::VerificationsController < Admin::ResourcesController

  def show
    render locals: { verification: verification,
                     dup_documents: dup_documents,
                     dup_names: dup_names,
                     dup_emails: dup_emails }
  end

  def update
    render locals: { verification: verification }
  end

  def confirm
    verification.confirm!(member: current_member)
    redirect_to admin_verification_path(verification), notice: 'Подтверждено'
  end

  def refuse
    verification.refuse!(member: current_member,
                        labels: verification_params[:review_result_labels],
                        user_comment: verification_params[:user_comment],
                        moderator_comment: verification_params[:moderator_comment])
    redirect_to admin_verification_path(verification), notice: 'Отвергнуто'
  end

  private

  def dup_documents
    Verification.where(document_number: verification.document_number).where.not(id: verification.id)
  end

  def dup_names
    Verification.where(name: verification.name, last_name: verification.last_name).where.not(id: verification.id)
  end

  def dup_emails
    Verification.where(email: verification.email).where.not(id: verification.id)
  end

  def verification
    @verification ||= Verification.find(params[:id])
  end

  def verification_params
    params.require(:verification).permit( :user_comment, :moderator_comment, :review_result_labels => [])
  end
end
