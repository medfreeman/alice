Alice::Application.routes.draw do
  match "/upload" => "assets#upload", via: :post
  
  resources :studios, only: [:new, :create, :update, :edit, :destroy] do 
    resources :students, only: [:index] do 
      resources :posts, only: [:index]
    end
  end
  resources :posts, except: [:show, :index]
  post 'posts/:id/feature' => 'posts#feature', as: :post_feature

  get "studios/(:studio_id)" => "posts#index", as: :studio_posts
  get "studios/:studio_id/posts/:id" => "posts#show", as: :studio_post
  get "studios/:studio_id/:id" => "posts#student_posts", as: :student_posts

  root "posts#index"

  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  

  devise_for :users, :controllers => {:confirmations => 'confirmations'}, :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    put "/confirm" => "confirmations#confirm"
  end

  
  scope :admin do
    get "users/upload" => 'users#upload_form', as: :users_upload
    post "users/upload" => 'users#upload_post', as: :users_upload_post
    post "users/create" => 'users#create', as: :users_create
    resources :users, controller: 'users'
  end
  
end
