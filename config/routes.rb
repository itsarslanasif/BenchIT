Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users

    root to: 'application#index'
    get '*path', to: 'application#index', format: false

    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :mentions, only: [] do
          collection do
            get :channels_list
            get :users_list
          end
        end
      end
      resources :workspaces do
        resources :profiles, only: [:index]
      end
      resources :bench_channels, only: [:create]
    end
    
    resources :workspaces, only: [:index, :create]
  end
end
