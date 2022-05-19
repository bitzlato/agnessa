class Admin::DashboardController < Admin::ApplicationController
  include RansackSupport
  skip_before_action :authorize_admin, only: [:index]

  private

  def model_class
    Verification
  end
end
