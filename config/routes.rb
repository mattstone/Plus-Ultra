Rails.application.routes.draw do
  devise_for :users 
  
  resources :users do 
    collection do     
      post :request_2fa
      post :confirm_2fa
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
end
