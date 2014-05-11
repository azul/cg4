Cg4::Application.routes.draw do
  resources :memberships

  resources :groups do
    resources :memberships
  end

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end
