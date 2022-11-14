Rails.application.routes.draw do


  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, controllers: { invitations: 'users_invitations' }

    namespace :api, :defaults => { :format => 'json' } do
      namespace :v1 do
      resources :workspaces, only: [:index,:create]
      end
    end

    root :to => "application#index"
    match "*path", to: "application#index", format: false, via: :get
  end

end
