class Admin::DashboardController < Admin::ApplicationController
  skip_before_action :admin_member, only: [:index]
end
