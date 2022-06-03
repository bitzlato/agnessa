class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  skip_before_action :verify_authenticity_token

  PERMITTED_ATTRIBUTES = [:applicant_comment, :name, :reason, :country, :birth_date, :gender, :last_name, :patronymic, :email, :document_number, {verification_documents_attributes: [:document_type_id, :file, :file_cache]}]

  helper_method :form_path, :external_id

  def new
    applicant = current_account.applicants.find_or_initialize_by(external_id: external_id)
    verification = applicant.verifications.new params.fetch(:verification, {}).permit(*PERMITTED_ATTRIBUTES)

    current_account.document_types.available.each do |document_type|
      verification.verification_documents.new document_type: document_type
    end
    if applicant.blocked?
      render :blocked, locals: {applicant: applicant }, status: :bad_request
    else
      render locals: {verification: verification}
    end
  end

  def create
    verification = applicant.verifications.create! verification_params.merge(remote_ip: request.remote_ip,
                                                                             user_agent: request.user_agent)
    render :created, locals: { verification: verification }
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Verification
    render :new, locals: { verification: e.record }, status: :bad_request
  end

  private

  def form_path
    Rails.application.routes.url_helpers.client_verifications_path params[:encoded_external_id]
  end

  def applicant
    raise HumanizedError, :no_external_id unless external_id.present?
    p2p_id = BarongClient.instance.get_p2pid_from_barong_uid(external_id)
    unless p2p_id.present?
      Bugsnag.notify(StandardError.new("Unknown P2P Changebot Id: #{external_id}"))
      raise HumanizedError, :invalid_barong_uid
    end
    @applicant ||= current_account.applicants.upsert!({external_id: external_id}, validate: false)
    @applicant.update_column(:legacy_external_id, p2p_id)
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
