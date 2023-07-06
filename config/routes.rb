Rails.application.routes.draw do
  root :to => redirect("/users/sign_in")
  get '/nana', to: 'users/sessions#new'
  get '/analytics', to: 'analytics#index'
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
    get '/home', to: 'transactions#index', as: :user_root
  end
  resources :transactions do
    collection do
       post :import
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
