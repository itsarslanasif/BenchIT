Rails.application.routes.draw do


  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, controllers: { invitations: 'users_invitations' }
    root to: 'application#index'
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :mentions, only: [] do
          collection do
            get :channels_list
            get :users_list
          end
        end
      end

      resources :bench_channels do
        resources :bookmarks, only: %i[create index]
      end

      namespace :v2 do
        resources :channels
        resources :groups
        resources :users
        resources :conversation_messages, only: :create
      end
      resources :workspaces do
        resources :profiles, only: [:index, :create]
      end
      resources :bench_channels, only: [:create]
      match "/workspaces/:workspace_id/invite", :to => "workspaces#invite", :via => "post"
    end

    get '*path', to: 'application#index', format: false
  end

end
