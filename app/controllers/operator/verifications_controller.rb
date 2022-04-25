class Operator::VerificationsController < Operator::ApplicationController
  def new
  end

  def create
    external_id = verification_params[:external_id]
    barong_uid = BarongClient.instance.get_barong_uid_from_changebot_id(external_id)
    if barong_uid.present?
      redirect_to client_short_new_verification_path(encoded_external_id: VerificationUrlGenerator.generate_token(barong_uid, current_account.secret))
    else
      redirect_to :new_operator_verification, notice: 'Extneral ID пользователя не найден'
    end
  end

  private

  def verification_params
    params.
      require(:verification).
      permit([:external_id])
  end
end
