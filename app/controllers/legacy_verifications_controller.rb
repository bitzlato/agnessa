class LegacyVerificationsController < API::APIController
  def index
    @verifications = Verification.all.order('created_at DESC')
    render json: @verifications.map { |x| x.legacy_show}
  end
end
