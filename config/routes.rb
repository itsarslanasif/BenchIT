Rails.application.routes.draw do
  default_url_options host: 'localhost', port: 5100 if Rails.env.development?
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, controllers: {
      invitations: 'users_invitations',
      sessions: 'users/sessions'
    }
    root to: 'application#index'
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :mentions, only: [] do
          collection do
            get :channels_list
            get :profiles_list
          end
        end

        resources :groups, only: %i[index show]
        resources :users, only: %i[index]
        resources :conversation_messages, only: %i[create destroy] do
          collection do
            get :send_message
            get :index_saved_messages
            get :recent_files
          end
          member do
            post :save_message
            delete :unsave_message
            get :bench_channel_messages, :group_messages, :profile_messages
          end
        end
        resources :favourites, only: %i[create destroy]

        resources :bench_channels, except: %i[new edit] do
          member do
            delete :leave
          end
        end

        resources :workspaces, only: %i[create] do
          member do
            post :invite
          end

          resources :profiles, only: %i[index create show] do
            collection do
              get :previous_direct_messages
            end
          end
        end

        resources :bookmarks, only: %i[create index]
        resources :reactions, only: %i[create destroy]
        resources :channel_participants, only: %i[create index]
        resources :draft_messages, only: %i[index create update destroy]
      end
    end

    get '*path', to: 'application#index', format: false, constraints: lambda { |req|
      req.path.exclude? 'rails/active_storage'
    }
  end
end
