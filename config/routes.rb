Rails.application.routes.draw do
  resources :products
  devise_for :users 
  
  resources :users do 
    collection do     
      post :request_2fa
      post :confirm_2fa
    end
  end
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'logout',    to: 'dashboard#logout'
    
    resources :users
  end
  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
end
