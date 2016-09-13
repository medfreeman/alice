Alice::Application.routes.draw do
  match "/upload" => "assets#upload", via: :post

  devise_for :users, :controllers => {:confirmations => 'confirmations'}, :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"
  end

  post 'posts/:id/feature'           => 'posts#feature', as: :post_feature


  resources :years, only: [:show] do
    resources :posts, except: [:show, :index]

    resources :studios, only: [:new, :create, :update, :edit, :destroy] do
      resources :students, only: [:index] do
        resources :posts, only: [:index]
      end
    end

    get "category/:slug/"              => "posts#tagged_posts", as: :category
    get "category/:slug/:id"           => "posts#show", as: :category_post

    get "studios/(:studio_id)"         => "posts#index", as: :studio_posts
    get "studios/:studio_id/recent"    => "posts#index", as: :studio_most_recent, filter: :most_recent
    get "studios/:studio_id/posts/:id" => "posts#show", as: :studio_post

    get "studios/:studio_id/tag/:slug" => "posts#tagged_posts", as: :studio_tag
    get "studios/:studio_id/:id"       => "posts#student_posts", as: :student_posts

    get 'tags'   => 'posts#tagged_posts', as: :tag_path
    get 'recent' => 'posts#index', filter: :most_recent, as: :most_recent
    get ':slug' => 'posts#index', as: :student
    get ':student/:slug' => 'posts#show', as: :student_post

    root "posts#index", as: :root_with_year

  end
  scope :admin do
    resources :years, only: [:new, :edit, :create] do
      get "users/upload" => 'users#upload_form', as: :users_upload
      post "users/upload" => 'users#upload_post', as: :users_upload_post
      post "users/create" => 'users#create', as: :users_create
      resources :users, controller: 'users'
    end
  end
  root "years#show"

end
