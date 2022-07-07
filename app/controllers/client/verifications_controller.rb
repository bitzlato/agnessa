class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  skip_before_action :verify_authenticity_token

  DEFAULT_REASON = :trusted_trader
  PERMITTED_ATTRIBUTES = [:name, :next_step, :document_type, :citizenship_country_iso_code, :birth_date, :last_name, :patronymic, :email, :document_number, {verification_documents_attributes: [:document_type_id, :file, :file_cache, :remove_file]}]

  helper_method :form_path, :external_id, :last_refused_verification

  before_action :detect_browser, only: %i[new step1 step2 step3 step4 create]

  VERIFICATION_ATTRS_WITH_STEP = {
    name: 1,
    last_name: 1,
    patronymic: 1,
    citizenship_country_iso_code: 1,
    birth_date: 1,
    email: 1,
    document_type: 2,
    document_number: 2,
    document3: 3,
    document4: 4
  }.with_indifferent_access.freeze

  def new
    @applicant = current_account.applicants.find_or_initialize_by(external_id: external_id)
    if applicant.verified?
      render :verified, locals: {applicant: applicant }
    elsif applicant.blocked?
      render :blocked, locals: {applicant: applicant }, status: :bad_request
    else
      return if check_for_existing_verification
      verification = applicant.verifications.new params.fetch(:verification, {}).permit(*PERMITTED_ATTRIBUTES)
      verification.copy_verification_attributes(last_refused_verification) if last_refused_verification.present?

      if verification.verification_documents.count != current_account.document_types.alive.count
        current_account.document_types.alive.order('position ASC').each do |document_type|
          verification.verification_documents.new document_type: document_type
        end
      end
      verification.citizenship_country_iso_code = Geocoder.search(request.remote_ip).first&.country if verification.citizenship_country_iso_code.nil?
      verification.document_type = verification.citizenship_country&.available_documents&.first if verification.document_type.nil?
      render locals: {verification: verification}
    end
  end

  def create
    return if check_for_existing_verification

    if is_mobile?
      verification = applicant.verifications.new verification_params.
        reverse_merge(remote_ip: request.remote_ip,
                      next_step: 1,
                      user_agent: request.user_agent,
                      reason: DEFAULT_REASON)

      verification.next_step = verification.next_step - 2 if back_step?

      if verification.next_step <= 0
        render :new, locals: { verification: verification }
      elsif verification.next_step <= 4
        render 'step'+verification.next_step.to_s, locals: { verification: verification }
      else
        verification.save!
        render :created, locals: { verification: verification }
      end
    else
      verification = applicant.verifications.create! verification_params.
        reverse_merge(remote_ip: request.remote_ip,
                      user_agent: request.user_agent,
                      reason: DEFAULT_REASON)
      render :created, locals: { verification: verification}
    end
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Verification
    report_exception e, true, params: params

    if is_mobile?
      render 'step'+minimal_step_with_errors(e.record.errors).to_s, locals: { verification: e.record }, status: :bad_request
    else
      render :new, locals: { verification: e.record }, status: :bad_request
    end
  end

  private

  def minimal_step_with_errors(errors)
    step_with_errors = []

    errors.map { |attr, msg| step_with_errors << VERIFICATION_ATTRS_WITH_STEP[attr] }

    verification_params[:verification_documents_attributes].each do |key, val|
      val = val.to_h
      document = VerificationDocument.new(val)
      document.validate

      if document.errors.to_h.find { |attr, msg| attr == :file}
        error_step = VERIFICATION_ATTRS_WITH_STEP['document'+document.document_type.step.to_s]
        step_with_errors << error_step if error_step
      end
    end

    report_exception "Empty next_step, but have error #{errors}", true, params: params if step_with_errors.empty?

    step_with_errors.compact.min || 1
  end

  def back_step?
    params[:submit] == 'back'
  end

  def check_for_existing_verification
    existing_verification = applicant.verifications.pending.last
    if existing_verification.present?
      render :created, locals: { verification: existing_verification }
    end
  end

  def detect_browser
    request.variant = params[:mobile] && browser.device.mobile?  ? :mobile : :desktop
  end

  def is_mobile?
    detect_browser == :mobile
  end

  def form_path
    Rails.application.routes.url_helpers.client_verifications_path params[:encoded_external_id]
  end

  def applicant
    @applicant ||= find_applicant
  end

  def last_refused_verification
    applicant.verifications.refused.last
  end

  def find_applicant
    raise HumanizedError, :no_external_id unless external_id.present?
    p2p_id = BarongClient.instance.get_p2pid_from_barong_uid(external_id)
    unless p2p_id.present?
      # Бывают ссылки вида https://check.changebot.org/verifications/verifications
      # их пропускаем
      # https://app.bugsnag.com/bitzlato/agnessa/errors/625fff2a5152420008eec2ba?filters[event.since]=30d&filters[error.status]=open
      Bugsnag.notify(StandardError.new("Unknown P2P Changebot Id: #{external_id}")) unless external_id=='verifications'
      raise HumanizedError, :invalid_barong_uid
    end
    applicant = current_account.applicants.upsert!({external_id: external_id}, validate: false)
    applicant.update_column(:legacy_external_id, p2p_id)
    applicant
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
