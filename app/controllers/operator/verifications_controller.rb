class Operator::VerificationsController < Operator::ApplicationController
  def new
  end

  def create
    extneral_id = verification_params[:external_id]
    p2p_id = BarongClient.instance.get_p2pid_from_barong_uid(extneral_id)
    if p2p_id.present?
      redirect_to client_short_new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token(extneral_id, current_account.secret))
    else
      redirect_to :new_operator_verification, notice: 'Extneral ID не найден'
    end
  end

  private

  def verification_params
    params.
      require(:verification).
      permit([:external_id])
  end
end
