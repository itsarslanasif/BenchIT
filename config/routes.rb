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

        resources :groups, only: %i[index show] do
          member do
            post :add_member
          end
        end
        resources :users, only: %i[index]
        resources :conversation_messages, only: %i[create update destroy] do
          collection do
            get :send_message
            get :index_saved_messages
            get :recent_files
            get :unread_messages
            post :last_messages
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
            delete :leave_channel
          end

          collection do
            get :joined_channels
          end
        end

        resources :workspaces, only: %i[index create] do
          member do
            post :invite
            get :switch_workspace
          end

          resources :profiles, only: %i[index create show update] do
            collection do
              get :previous_direct_messages
            end
            member do
              post :set_status
              post :clear_status
              get :set_is_active
              get :remove_is_active
            end
          end
        end
        resources :downloads, only: %i[index create destroy] do
          collection do
            post :clear_all
          end
        end
        resources :statuses, only: %i[index destroy]
        resources :pins, only: %i[index create destroy]
        resources :bookmarks, only: %i[index create update destroy]
        resources :reactions, only: %i[create destroy]
        resources :channel_participants, only: %i[create index] do
          collection do
            post :join_public_channel
            post :mute_channel
            post :unmute_channel
          end
        end
        resources :draft_messages, only: %i[index create update destroy]
      end
    end

    get '*path', to: 'application#index', format: false, constraints: lambda { |req|
      req.path.exclude? 'rails/active_storage'
    }
  end
end
