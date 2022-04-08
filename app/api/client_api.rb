class ClientApi < Grape::API
  prefix :api
  format :json

  helpers do
    def current_account
      RequestStore.store[:current_account]
    end

    def jwt_token
      request.headers['Authorization'].split.last
    end

    def authenticate!
      return error!('401 Unauthorized', 401) unless current_account and current_account.api_jwk.present?

      payload, _header = Agnessa::JWT.decode_and_verify!(jwt_token, current_account.api_jwk)
      return error!('401 Unauthorized', 401) unless payload.present?
    end
  end

  resource :users do
    desc 'Get User Info'
    get '/:id' do
      authenticate!

      applicant = current_account.applicants.find_by_external_id!(params[:id])
      {
        first_name: applicant.first_name,
        last_name: applicant.first_name,
        emails: applicant.emails,
        confirmed_at: applicant.confirmed_at
      }
    end
  end
end