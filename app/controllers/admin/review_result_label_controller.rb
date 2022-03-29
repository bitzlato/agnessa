class Admin::ReviewResultLabelController < Admin::ApplicationController
  before_action :superadmin?

  def index
    @labels = ReviewResultLabel.all
  end
end
