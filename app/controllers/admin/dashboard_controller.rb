class Admin::DashboardController < Admin::ApplicationController
  include RansackSupport

  private

  def model_class
    Verification
  end
end
