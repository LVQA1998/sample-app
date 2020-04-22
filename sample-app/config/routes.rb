Rails.application.routes.draw do
  get 'users/new'
  scope "(:locale)", locale: /en|vi/ do
  resources :microposts
  resources :users
  resources :home
  get "static_pages/home", to: "static_pages#home"
  get "static_pages/about", to:"static_pages#about"
  get "static_pages/help", to: "static_pages#help"
  get "static_pages/contact", to: "static_pages#contact"
  get "users/new", to: "users#signup"
  root "static_pages#home"
  end
end
