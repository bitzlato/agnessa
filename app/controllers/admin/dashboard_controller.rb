class Admin::DashboardController < Admin::ApplicationController
  include RansackSupport
  skip_before_action :admin_member, only: [:index]

  private

  def model_class
    Verification
  end
end
