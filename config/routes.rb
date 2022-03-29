require 'sidekiq/web'

Rails.application.routes.draw do
  class ClientConstraint
    def matches?(request)
      RequestStore.store[:current_client] = Client.find_by_subdomain(request.subdomain)
    end
  end

  root to: redirect('/admin')

  namespace :admin do
    get 'review_result_label/index'
  end

  constraints ClientConstraint.new do
    namespace :api do
      get ENV.fetch('USERS_PATH','users.json'), to: 'verifications#legacy_index'
    end

    namespace :admin do
      get '/' => 'verifications#index'
      resources :review_result_label, only: [:index]
      resources :moderation, only: [:index] do
        member  do
          post :confirm
          post :refuse
        end
      end
      resources :client_users
      resources :verifications do
        member  do
          post :confirm
          post :refuse
        end
      end

      resource :client, only: [:show, :update] do
        post :recreate_secret
        post :verification_callback_test
      end
    end

    scope module: 'client' do
      resources :applicants, only: [], param: :encoded_external_id do
        member do
          resources :verifications, only: [:new, :create]
        end
      end
    end
  end

  mount Sidekiq::Web => "/sidekiq"
end
