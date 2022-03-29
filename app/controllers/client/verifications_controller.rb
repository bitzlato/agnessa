class Client::VerificationsController < Client::ApplicationController
  layout 'verification'

  def new
    verification = applicant.verifications.new verification_params
    render locals:{verification: verification, encoded_external_id: params[:encoded_external_id]}
  end

  def create
    encoded_external_id = params[:encoded_external_id]
    verification = applicant.verifications.create!(verification_params)
    render :created, locals: {verification: verification, encoded_external_id: encoded_external_id}
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Verification
    render :new, locals: {verification: verification, encoded_external_id: encoded_external_id}
  end

  private

  def applicant
    @applicant ||= find_applicant
  end

  def find_applicant
    payload = VerificationUrlGenerator.payload_from_token(params[:encoded_external_id], current_account.secret)
    raise ActiveRecord::RecordNotFound unless payload.present?
    current_account.applicants.find_or_create_by!(external_id: payload)
  end

  def verification_params
    params.fetch(:verification, {}).permit!
  end
end
