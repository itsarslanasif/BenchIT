Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, only: [:sessions]

    namespace :api, defaults: { format: 'json' } do
    end

    root to: 'application#index'
    get '*path', to: 'application#index', format: false
  end
end
