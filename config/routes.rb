Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  localized do
    devise_for :users

    namespace :api, :defaults => { :format => 'json' } do
      # devise_for :users

    end


    root :to => "application#index"
    match "*path", to: "application#index", format: false, via: :get
  end
end
