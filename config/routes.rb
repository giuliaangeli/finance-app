Rails.application.routes.draw do
  root to: 'welcome#index'
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
    get '/home', to: 'users_backoffice#page', as: :user_root
  end
  resources :transactions

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
