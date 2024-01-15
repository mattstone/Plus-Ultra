require 'oauth'
require 'json'

class ISTwitter < ISCommon
  
  def initialize
    @consumer_key        = ENV['X_API_KEY']
    @consumer_secret     = ENV['X_API_KEY_SECRET']
    @bearer_token        = ENV['X_BEARER_TOKEN']
    @access_token        = ENV['X_ACCESS_TOKEN']
    @access_token_secret = ENV['X_ACCESS_TOKEN_SECRET']
    
    
    # @base_url            = "https://api.twitter.com/2/tweets"
    @base_url            = "https://api.twitter.com/2/"
  end
  
  def self.has_credentials?
     !ENV['X_ACCESS_TOKEN'].blank?        and 
     !ENV['X_ACCESS_TOKEN_SECRET'].blank? and 
     !ENV['X_BEARER_TOKEN'].blank?        and 
     !ENV['X_API_KEY'].blank?             and
     !ENV['X_API_KEY_SECRET'].blank?
  end 
  
end

# curl "https://api.twitter.com/2/users/by/username/zenmacrotrader" -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAI1orwEAAAAAxHXTvgT2XmRAdpxhvSEtcUMqDQ0%3D3GE3XQpIqmfw49vEy0gvQhsF3sOQW3T5MrORuA4IXPNtbErNgK"
# 
# 
# X_API_KEY             = "goHxu9zq7KE6m7FQSJ1r7XTwK"
# X_API_KEY_SECRET      = "g397jHjWZLGxmXaWjCtTTlvYLXpauw4HpF4w7A1CS4FKaiDyOF"
# X_BEARER_TOKEN        = "AAAAAAAAAAAAAAAAAAAAAI1orwEAAAAAxHXTvgT2XmRAdpxhvSEtcUMqDQ0%3D3GE3XQpIqmfw49vEy0gvQhsF3sOQW3T5MrORuA4IXPNtbErNgK"
# X_ACCESS_TOKEN        = "1629629617136087040-DJ4B7bR3ta4GdIyFKFVXVd6d6OovKo"
# X_ACCESS_TOKEN_SECRET = "o0S70ElIZWBlaHvmjjEFOY0TfMZGiqcU0Mhy8CVTPgSri"
# 

