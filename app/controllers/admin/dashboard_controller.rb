class Admin::DashboardController < Admin::ApplicationController
  def index
    render locals: {
      pending_verifications: pending_verifications,
      paginated_records: paginate(q.result)
    }
  end

  private

  def pending_verifications
    Verification.where(status: 'pending')
  end

  def q
    pending_verifications.ransack params[:q]
  end
end
