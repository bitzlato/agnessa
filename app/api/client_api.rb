class ClientApi < Grape::API
  prefix :api
  version 'v1', using: :path
  format :json

  helpers do
    def current_account
      RequestStore.store[:current_account]
    end

    def jwt_token
      request.headers['Authorization'].split.last
    end

    def authenticate!
      return error!('401 Unauthorized', 401) unless current_account and current_account.api_jwt_public_key.present?

      payload, _header = Agnessa::JWT.decode_and_verify!(jwt_token, current_account.api_jwt_public_key)
      return error!('401 Unauthorized', 401) unless payload.present?
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error! e.message, 404
  end

  resource :applicants do
    desc 'Get Applicant Info'
    get '/:id' do
      authenticate!

      applicant = current_account.applicants.find_by_external_id!(params[:id])
      {
        first_name: applicant.first_name,
        last_name: applicant.last_name,
        patronymic: applicant.patronymic,
        emails: applicant.emails,
        confirmed_at: applicant.confirmed_at
      }
    end
  end
end
