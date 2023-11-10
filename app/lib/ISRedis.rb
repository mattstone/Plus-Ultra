class ISRedis 
  
  def self.set(key, object)
    $redis.set(key, object.to_json)
  end
  
  def self.set_ex(key, object, ex = 60) # expires in 60 seconds
    $redis.set(key, object.to_json)
  end
  
  def self.get(key)
    JSON.parse($redis.get(key))
  end
  
end