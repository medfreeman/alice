Alice::Application.routes.draw do
  resources :studios do 
    resources :posts, only: [:show, :index]
  end
  resources :posts, except: [:show, :index]

  root "pages#home"    
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  
    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users

  end
  
end
