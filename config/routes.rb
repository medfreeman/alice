Alice::Application.routes.draw do
  resources :studios, only: [:new, :edit, :create] do 
    resources :students, only: [:index] do 
      resources :posts, only: [:index]
    end
  end
  resources :posts, except: [:show, :index]

  post 'posts/:id/feature' => 'posts#feature', as: :post_feature

  get "studios/(:studio_id)" => "posts#index", as: :studio
  get "studios/:studio_id/posts/:id" => "posts#show", as: :studio_post
  get "studios/:studio_id/:id" => "posts#student_posts", as: :studio_student

  root "posts#index"

  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  

  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
  end
  
end
