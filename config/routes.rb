Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root to: 'posts#index', as: :authenticated_root
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  
  resources :users
  resources :posts, only: %i(show)
  resources :kintone_apps, only: %i(show edit update domain_update) do
    member do
      patch 'domain_update'
    end
  end
end
