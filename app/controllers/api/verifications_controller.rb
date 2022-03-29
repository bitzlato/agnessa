
class API::VerificationsController < API::APIController

  def index
    @verification = Verification.all
    render json: @verification
  end

  def legacy_index
    @verifications = Verification.all.order('created_at DESC')
    render json: @verifications.map { |x| x.legacy_show}
  end

end
