class Admin::VerificationsController < Admin::ResourcesController
  skip_before_action :admin_member, only: [:show, :new, :create, :update ]

  helper_method :similar_emails
  helper_method :similar_names
  helper_method :similar_documents

  def new
  end

  def create
    external_id = params.require(:verification).permit(:external_id).fetch(:external_id, nil)
    if external_id.blank?
      redirect_to :new_admin_verification, notice: 'Укажите Extneral ID'
    else
     barong_uid = BarongClient.instance.get_barong_uid_from_changebot_id(external_id)
      if barong_uid.present?
        redirect_to client_short_new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token(barong_uid, current_account.secret))
      else
        redirect_to :new_admin_verification, notice: 'Extneral ID пользователя не найден'
      end
    end
  end

  def show
    render locals: { verification: verification }
  end

  def update
    if ENV.true?('AGNESSA_LOCK_EXTERNAL_VERIFICATIONS') and verification.legacy_external_id.present?
      raise HumanizedError, :cant_edit_legacy_verification
    end

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
    redirect_to_next reason: verification.reason, notice: 'Подтверждено'
  rescue ActiveRecord::RecordInvalid => err
    raise err unless err.record.is_a? Verification
    err.record.restore_status!
    render :show, locals: { verification: err.record }
  end

  def refuse
    verification.refuse!(member: current_member,
                         labels: verification_params[:review_result_labels],
                         public_comment: verification_params[:public_comment],
                         private_comment: verification_params[:private_comment])
    redirect_to_next reason: verification.reason, notice: 'Отвергнуто'
  rescue ActiveRecord::RecordInvalid => err
    raise err unless err.record.is_a? Verification
    err.record.restore_status!
    render :show, locals: { verification: err.record }
  end

  private

  def redirect_to_next(reason:, notice: nil)
    next_verification = Verification.pending.where(reason: reason).first
    if next_verification
      redirect_to admin_verification_path(next_verification), notice: notice
    else
      if is_admin?
        redirect_to admin_verifications_path, notice: notice
      else
        redirect_to admin_root_path, notice: notice
      end
    end
  end

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
    @verification ||= Verification.member_scope(current_member).find(params[:id])
  end

  def verification_params
    params.require(:verification).permit( :public_comment, :private_comment, :review_result_labels => [])
  end
end
