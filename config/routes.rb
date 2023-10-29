Rails.application.routes.draw do
  resources :subscribers, :blogs
  devise_for :users 
  
  resources :users do 
    collection do     
      post :request_2fa
      post :confirm_2fa
    end
  end

  # Newsletter subscription  
  post 'subscribe_to_newsletter', to: 'subscribers#subscribe_to_newsletter'  
  get ' confirm_news_letter_subscription', to: 'subscribers#confirm_news_letter_subscription'  
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'logout',    to: 'dashboard#logout'
    
    resources :users,
              :products,
              :blogs
            
    resources :mailing_lists do 
      resources :subscribers, controller: 'mailing_lists/subscribers' do 
      end
    end
  end  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
end
