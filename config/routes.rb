Rails.application.routes.draw do
  resources :events
  default_url_options host: ENV['DOMAIN']
  
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
  get 'confirm_news_letter_subscription',  to: 'subscribers#confirm_news_letter_subscription'  
  get 'unsubscribe_from_newsletter/:mailing_list_id/:subscriber_id', to: 'subscribers#unsubscribe', as: "unsubscribe"
  
  # Imager serving and marketing 
  get 'bitly/:bitly', to: "home#bitly", as: "bitly"
  get 'image/:image', to: "home#image", as: "image"
  
  get 'image_s/:image/:campaign_id/:communication_id/:subscriber_id', to: 'home#image_s', as: "image_s"
  get 'image_u/:image/:campaign_id/:communication_id/:user_id',       to: 'home#image_u', as: "image_u"
  
  # Events 
  get 'events/accept_invitation/:event_id/:uuid',  to: 'events#accept_invitation',  as: "accept_invitation"
  get 'events/decline_invitation/:event_id/:uuid', to: 'events#decline_invitation', as: "decline_invitation"
  
  
  
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
    
    resources :products,
              :transactions,
              :blogs,
              :orders,
              :communications,
              :terms_and_conditions
              
    resources :users do 
      resources :events do 
        collection do 
          post 'search_for_invitee'
          post 'add_invitee'
          post 'remove_invitee'
        end
      end
      
    end
              
    resource :communications do 
      member do 
        post ':id/test', to: 'communications#test',           as: 'test'
        post ':id/preview', to: 'communications#preview',     as: "preview"
        post 'preview_new', to: 'communications#preview_new', as: "preview_new"
      end
    end 
                  
    resources :subscriptions do 
      member do 
        post 'cancel'
      end
    end
    
    resources :channels do 
      resources :campaigns do 
        member do 
          get 'qr_code'
        end
      end
    end
            
    resources :mailing_lists do 
      resources :subscribers, controller: 'mailing_lists/subscribers' do 
      end
      member do 
         post 'subscribers_count'
      end
    end
    
    resources :bulk_emails do 
      member do 
        post 'send_bulk_email'
      end
    end
    
  end  
  
  # For Testing and Development purposes
  if !Rails.env.production?
    get 'set_for_testing', to: 'home#set_for_testing'
    get 'qr_code',         to: 'home#qr_code'
    
    get 'session_data',    to: 'home#session_data'
    get 'session_clear',   to: 'home#session_clear'
    
    get 'calendar_test',   to: 'home#calendar_test'
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
end
