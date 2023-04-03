Rails.application.routes.draw do
  default_url_options host: 'localhost', port: 5100 if Rails.env.development?
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, controllers: {
      invitations: 'users_invitations',
      sessions: 'users/sessions'
    }
    devise_scope :user do
      get 'check_auth', to: 'users/sessions#check_auth'
    end
    root to: 'application#index'
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :mentions, only: [] do
          collection do
            get :channels_list
            get :profiles_list
          end
        end

        resources :groups, only: %i[index show create] do
          member do
            post :add_member
          end
        end
        resources :users, only: %i[index create] do
          member do
            get :verify_email
          end
        end
        resources :bench_conversations, only: %i[update]
        resources :schedule_messages, only: %i[index update destroy] do
          member do
            get :send_now
          end
        end
        resources :conversation_messages, only: %i[create update destroy] do
          collection do
            get :sent_message
            get :recent_files
            get :unread_messages
            get :threads
            get :reactions_and_mentions
          end
          member do
            get :bench_channel_messages, :group_messages, :profile_messages
          end
        end
        resources :saved_items, only: %i[index create destroy]
        resources :favourites, only: %i[create destroy]
        resources :invites, only: %i[create update] do
          member do
            get :accept_invitation
          end
        end
        resources :searches, only: %i[index]

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
            get :switch_workspace
          end

          resources :profiles, only: %i[index create show update] do
            member do
              post :set_status
              post :clear_status
              get :set_is_active
              get :remove_is_active
            end
            resource :preference, only: %i[update]
          end
        end
        resources :downloads, only: %i[index create destroy] do
          collection do
            post :clear_all
          end
        end
        resources :statuses, only: %i[index destroy]
        resources :pins, only: %i[index create destroy]
        resources :bookmarks, only: %i[create update destroy]
        resources :bookmark_folders, only: %i[create update destroy]
        resources :reactions, only: %i[create destroy]
        resources :direct_message_users, only: %i[index destroy] do
          collection do
            get :previous_direct_messages
            get :recent_direct_messages
          end
        end
        resources :channel_participants, only: %i[index create destroy] do
          collection do
            post :join_public_channel
            post :mute_channel
            post :unmute_channel
            post :invite_outsider
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
