class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  skip_before_action :verify_authenticity_token

  PERMITTED_ATTRIBUTES = [:applicant_comment, :name, :reason, :country, :birth_date, :gender, :last_name, :patronymic, :email, :document_number, {verification_documents_attributes: [:document_type_id, :file, :file_cache]}]

  helper_method :form_path, :external_id

  def new
    @applicant = current_account.applicants.find_or_initialize_by(external_id: external_id)
    if applicant.verified?
      render :verified, locals: {applicant: applicant }
    elsif applicant.blocked?
      render :blocked, locals: {applicant: applicant }, status: :bad_request
    else
      check_for_existing_verification and return
      last_refused_verification = applicant.verifications.refused.last
      verification = applicant.verifications.new params.fetch(:verification, {}).permit(*PERMITTED_ATTRIBUTES)
      verification.copy_verification_attributes(last_refused_verification) if last_refused_verification.present?
      current_account.document_types.available.each do |document_type|
        verification.verification_documents.new document_type: document_type
      end
      render locals: {verification: verification, last_refused_verification: last_refused_verification}
    end
  end

  def create
    check_for_existing_verification and return
    verification = applicant.verifications.create! verification_params.merge(remote_ip: request.remote_ip,
                                                                             user_agent: request.user_agent)
    render :created, locals: { verification: verification }
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Verification
    render :new, locals: { verification: e.record }, status: :bad_request
  end

  private

  def check_for_existing_verification
    existing_verification = applicant.verifications.pending.last
    if existing_verification.present?
      render("existing_verification", locals: {verification: existing_verification})
    end
  end

  def form_path
    Rails.application.routes.url_helpers.client_verifications_path params[:encoded_external_id]
  end

  def applicant
    @applicant ||= begin
      raise HumanizedError, :no_external_id unless external_id.present?
      p2p_id = BarongClient.instance.get_p2pid_from_barong_uid(external_id)
      unless p2p_id.present?
        Bugsnag.notify(StandardError.new("Unknown P2P Changebot Id: #{external_id}"))
        raise HumanizedError, :invalid_barong_uid
      end
      current_account.applicants.upsert!({external_id: external_id}, validate: false)
      @applicant.update_column(:legacy_external_id, p2p_id)
      @applicant
   end
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
