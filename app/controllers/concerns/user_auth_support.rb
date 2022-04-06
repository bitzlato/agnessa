module UserAuthSupport
  extend ActiveSupport::Concern

  included do

    before_action :require_login

    def not_authenticated
      flash_alert! :not_authenticated
      redirect_to new_public_session_url
    end
  end
end
