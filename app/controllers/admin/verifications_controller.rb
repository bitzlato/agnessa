class Admin::VerificationsController < Admin::ResourcesController

  helper_method :similar_emails
  helper_method :similar_names
  helper_method :similar_documents

  def show
    render locals: { verification: verification }
  end

  def update
    case params[:commit]
    when 'refuse'
      refuse
    when 'confirm'
      confirm
    else
      raise 'WTF'
    end
  end

  def confirm
    verification.confirm!(member: current_member)
    redirect_to admin_verification_path(verification), notice: 'Подтверждено'
  rescue ActiveRecord::RecordInvalid => err
    render :show, locals: { verification: err.record } if err.record.is_a? Verification
  end

  def refuse
    verification.refuse!(member: current_member,
                         labels: verification_params[:review_result_labels],
                         public_comment: verification_params[:public_comment],
                         private_comment: verification_params[:private_comment])
    redirect_to admin_verification_path(verification), notice: 'Отвергнуто'
  rescue ActiveRecord::RecordInvalid => err
    render :show, locals: { verification: err.record } if err.record.is_a? Verification
  end

  private

  def similar_documents
    Verification.where(document_number: verification.document_number).where.not(id: verification.id)
  end

  def similar_names
    Verification.where(name: verification.name, last_name: verification.last_name).where.not(id: verification.id)
  end

  def similar_emails
    return Verification.none if verification.email.nil?

    Verification.where(email: verification.email).where.not(id: verification.id)
  end

  def verification
    @verification ||= Verification.find(params[:id])
  end

  def verification_params
    params.require(:verification).permit( :public_comment, :private_comment, :review_result_labels => [])
  end
end
