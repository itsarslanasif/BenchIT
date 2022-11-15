Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users

    namespace :api, defaults: { format: 'json' } do
      resources :workspaces do
        resources :profiles, only: [:index]
      end
      resources :bench_channels, only: [:create]
    end

    resources :workspaces, only: [:index, :create]

    root to: 'application#index'
    get '*path', to: 'application#index', format: false
  end
end
