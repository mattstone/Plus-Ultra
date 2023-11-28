class ISTime 

  def self.times_zones_for_select 
    ActiveSupport::TimeZone.all.inject([]) { |array, tz| array << tz.tzinfo.identifier }
  end
  
  def self.default_time_zone 
    ActiveSupport::TimeZone['Australia/Sydney']
  end

end