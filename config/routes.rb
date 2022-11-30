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

        resources :channels, only: [:index, :show, :create, :destroy]
        resources :groups, only: [:index, :show]
        resources :users, only: [:index, :show]
        resources :conversation_messages, only: [:create, :destroy]
        resources :favourites, only: [:create, :destroy]

        resources :bench_channels, only: %i[create] do
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
      end
    end

    get '*path', to: 'application#index', format: false
  end
end
