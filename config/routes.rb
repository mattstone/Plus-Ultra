Rails.application.routes.draw do
  resources :subscriptions
  resources :orders
  resources :subscribers, :blogs
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # devise_for :users, controllers: { sessions: 'users/sessions' }
  
  resources :users do 
    collection do     
      post :request_2fa
      post :confirm_2fa
      
      post :signup_send_2fa 
      post :signup_confirm_2fa
    end
  end
  
  resources :products do 
    member do 
      post 'add_to_shopping_cart',      to: "products#add_to_shopping_cart"
      post 'remove_from_shopping_cart', to: "products#remove_from_shopping_cart"
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
  post 'webhooks/twilio',                  to: 'webhooks#twilio'
  post 'webhooks/stripe',                  to: 'webhooks#stripe'
  
  # Checkout 
  get  'checkout',                         to: "checkout#index"
  post 'checkout',                         to: "checkout#index"
  post 'checkout_create_account',          to: "checkout#checkout_create_account"
  post 'checkout_pay_now',                 to: "checkout#pay_now"
  post 'checkout_subscribe/:product_id',   to: "checkout#checkout_subscribe"

  # Newsletter subscription  
  post 'subscribe_to_newsletter',          to: 'subscribers#subscribe_to_newsletter'  
  get ' confirm_news_letter_subscription', to: 'subscribers#confirm_news_letter_subscription'  
  
  # Imager serving and marketing 
  get 'bitly/:bitly', to: "home#bitly", as: "bitly"
  get 'image/:image', to: "home#image", as: "image"
  
  namespace :dashboard do 
    get 'dashboard', to: 'dashboard#index'

    resources :users, 
              :orders, 
              :products
              
    resources :subscriptions do 
      member do 
        post 'cancel'
      end
    end
              
    resources :orders do 
    end
  end
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'logout',    to: 'dashboard#logout'
    
    resources :users,
              :products,
              :transactions,
              :blogs,
              :orders,
              :communications
              
    resources :subscriptions do 
      member do 
        post 'cancel'
      end
    end
    
    resources :channels do 
      resources :campaigns
    end
            
    resources :mailing_lists do 
      resources :subscribers, controller: 'mailing_lists/subscribers' do 
      end
    end
  end  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  if !Rails.env.production?
    get 'set_for_testing', to: 'home#set_for_testing'
    get 'qr_code',         to: 'home#qr_code'
  end
  
  root 'home#index'
end
