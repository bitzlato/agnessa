class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  PERMITTED_ATTRIBUTES = %i[name reason country last_name email passport_data documents]

  helper_method :form_path

  def new
    verification = applicant.verifications.new params.fetch(:verification, {}).permit(*PERMITTED_ATTRIBUTES).merge(external_id: external_id)
    render locals: {verification: verification}
  end

  def create
    verification = applicant.verifications.create! verification_params.merge(external_id: external_id)
    render :created, locals: { verification: verification }
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Verification
    render :new, locals: { verification: e.record }
  end

  private

  def form_path
    Rails.application.routes.url_helpers.client_verifications_path params[:encoded_external_id]
  end

  def applicant
    @applicant ||= current_account.applicants.find_or_create_by!(external_id: external_id)
  end

  def external_id
    VerificationUrlGenerator.payload_from_token(params[:encoded_external_id], current_account.secret)
  end

  def verification_params
    params.
      require(:verification).
      permit(*PERMITTED_ATTRIBUTES)
  end
end
