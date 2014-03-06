Cg4::Application.routes.draw do
  resources :groups

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end