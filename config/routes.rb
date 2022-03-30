require 'sidekiq/web'

module ClientConstraint
  def self.matches?(request)
    (RequestStore.store[:current_account] = Account.find_by_subdomain(request.subdomain)).present?
  end
end

module PublicConstraint
  def self.matches?(request)
    request.subdomain.blank?
  end
end

Rails.application.routes.draw do
  default_url_options Rails.configuration.application.default_url_options.symbolize_keys

  scope as: :public, module: :public, subdomain: '', constraints: PublicConstraint do
    root to: 'landing#index'
    mount Sidekiq::Web => "/sidekiq"
  end

  scope constraints: ClientConstraint do
    get ENV.fetch('USERS_PATH','users.json'), to: 'legacy_verifications#index'

    scope as: :admin, module: :admin do
      resources :applicants, only: [:index, :show] do
        post :block, on: :member
        post :unblock, on: :member
      end

      root to: 'dashboard#index'
      resources :members
      resources :review_result_labels
      resources :verifications do
        member  do
          post :confirm
          post :refuse
        end
      end

      resource :account, only: [:show, :update] do
        post :recreate_secret
        post :verification_callback_test
      end
    end

    scope as: :client, module: :client do
      resources :applicants, only: [], param: :encoded_external_id do
        member do
          resources :verifications, only: [:new, :create]
        end
      end
    end
  end

  match '*anything', to: 'errors#not_found', via: %i[get post]
  match '', to: 'errors#not_found', via: %i[get post]
end
