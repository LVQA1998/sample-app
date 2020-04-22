Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    
    get "static_pages/home", to: "static_pages#home"
    get "static_pages/about", to: "static_pages#about"
    get "static_pages/help", to: "static_pages#help"
    get "static_pages/contact", to: "static_pages#contact"
    get "users/signup", to: "users#new"
    get "sessions/login", to: "sessions#new"
    post "sessions/login", to: "sessions#create"
    delete "sessions/logout", to: "sessions#destroy"
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(destroy show index)
    resources :microposts, only: [:create, :destroy]
    resources :users
  end
end
