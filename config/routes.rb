Rails.application.routes.draw do
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
            get :users_list
          end
        end

        resources :groups, only: %i[index show]
        resources :users, only: %i[index show] do
          collection do
            get :previous_direct_messages
          end
        end
        resources :conversation_messages, only: %i[create destroy] do
          collection do
            get :send_message
          end
        end
        resources :favourites, only: %i[create destroy]

        resources :bench_channels, except: %i[new edit] do
          member do
            delete :leave
          end

          resources :bookmarks, only: %i[create index]
        end

        resources :workspaces, only: %i[create] do
          member do
            post :invite
          end

          resources :profiles, only: %i[index create]
        end

        resources :reactions, only: %i[create destroy]
        resources :channel_participants, only: %i[create]
        resources :draft_messages, only: %i[create]
      end
    end

    get '*path', to: 'application#index', format: false
  end
end
