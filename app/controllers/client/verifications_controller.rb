class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  PERMITTED_ATTRIBUTES = [:name, :reason, :country, :last_name, :patronymic, :email, :document_number, {documents: []}].freeze

  helper_method :form_path, :external_id

  def new
    verification = applicant.verifications.new params.fetch(:verification, {}).permit(*PERMITTED_ATTRIBUTES).merge(external_id: external_id)
    if applicant.blocked?
      render :blocked, locals: {verification: verification, applicant: applicant }
    else
      render locals: {verification: verification}
    end
  end

  def create
    verification = applicant.verifications.create! verification_params.merge(external_id: external_id, ip: request.remote_ip, user_agent: request.user_agent)
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
    uid = BarongClient.instance.get_uid_from_changebot_id(external_id)
    applicant_external_id = uid.present? ? uid : "LEGACY_#{external_id}"
    @applicant ||= current_account.applicants.find_or_create_by!(external_id: applicant_external_id)
    @applicant.update_column(:legacy_external_id, external_id)
    @applicant
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
