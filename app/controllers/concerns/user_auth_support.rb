module UserAuthSupport
  extend ActiveSupport::Concern

  included do
    before_action :basic_auth

    attr_reader :current_user
    helper_method :current_user

    private

    def basic_auth
      authenticate_or_request_with_http_basic do |user, password|
        user = User.find_by_email(user)
        if user && user.authenticate(password)
          @current_user = user
        end
      end
    end
  end
end
