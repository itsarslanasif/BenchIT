Rails.application.routes.draw do


  mount ActionCable.server => '/cable'

  localized do
    devise_for :users, controllers: { invitations: 'users_invitations' }
    namespace :api, :defaults => { :format => 'json' } do
      # devise_for :users
      resources :workspaces, only: [:index,:create]

    end


    root :to => "application#index"
    match "*path", to: "application#index", format: false, via: :get
  end

end
