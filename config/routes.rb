Rails.application.routes.draw do
  resources :subscribers, :blogs, :products
  devise_for :users
  # devise_for :users, controllers: { sessions: 'users/sessions' }
  
  resources :users do 
    collection do     
      post :request_2fa
      post :confirm_2fa
      
      post :signup_send_2fa 
      post :signup_confirm_2fa
    end
  end
  
  resources :transactions do 
    collection do 
      post 'stripe_payment_intent/product_id', to: 'transactions#stripe_payment_intent'
      get  'complete', to: 'transaction/complete'
    end
    
    post 'poll_for_webhook_response', to: 'transactions#poll_for_webhook_response'
  end
  
  # webhooks 
  post 'webhooks/stripe',                  to: 'webhooks#stripe'

  # Newsletter subscription  
  post 'subscribe_to_newsletter',          to: 'subscribers#subscribe_to_newsletter'  
  get ' confirm_news_letter_subscription', to: 'subscribers#confirm_news_letter_subscription'  
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'logout',    to: 'dashboard#logout'
    
    resources :users,
              :products,
              :transactions,
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
