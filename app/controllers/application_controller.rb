class ApplicationController < ActionController::Base
  def per_page
    params[:per]
  end

  def page
    params[:page]
  end
end