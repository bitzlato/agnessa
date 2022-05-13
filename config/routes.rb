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

module LegacyConstraint
  def self.matches?(request)
    return false unless ENV.key?('AGNESSA_LEGACY_VERIFICATION_HOST')
    legacy_verification_host = ENV.fetch('AGNESSA_LEGACY_VERIFICATION_HOST')
    legacy_verification_host.present? and request.host == legacy_verification_host
  end
end

Rails.application.routes.draw do
  concern :archivable do
    member do
      delete :archive
      post :restore
    end
  end

  default_url_options Rails.configuration.application.default_url_options.symbolize_keys

  scope as: :legacy, module: :legacy, constraints: LegacyConstraint do
    get ENV.fetch('USERS_PATH','users.json'), to: 'verifications#index'
    resources :verifications, only: [:show]
    # get '/' => 'verifications#legacy_root'
    get '/' => 'verifications#legacy_show'
    get '*anything' => 'verifications#legacy_show'
  end

  scope as: :public, module: :public, subdomain: '', constraints: PublicConstraint do
    root to: 'landing#index'
    mount Sidekiq::Web => "/sidekiq"

    resources :users, only: %i[new create]
    resources :sessions, only: %i[new create] do
      collection do
        delete :destroy
      end
    end
    resources :password_resets, only: %i[new create edit update]
  end

  scope module: :user, subdomain: '', constraints: PublicConstraint do
    resource :profile, only: [:show, :update], controller: 'profile'
  end

  scope constraints: ClientConstraint do
    mount ClientApi => '/'

    namespace :operator do
      resources :verifications, only: [:create, :new]
    end

    scope as: :admin, module: :admin do
      resources :applicants, only: [:index, :show] do
        post :block, on: :member
        post :unblock, on: :member
      end

      root to: 'dashboard#index'
      resources :members, only: [:index, :show] do
        concerns :archivable
      end
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

      resource :operator_statistics, only: [:show]
    end

    scope as: :client, module: :client do
      resources :applicants, only: [], param: :encoded_external_id do
        member do
          resources :verifications, only: [:new, :create]
        end
      end

      get 'v/:encoded_external_id', to: 'verifications#new', as: :short_new_verification
    end
  end

  match '*anything', to: 'application#not_found', via: %i[get post]
  match '', to: 'application#not_found', via: %i[get post]


end
