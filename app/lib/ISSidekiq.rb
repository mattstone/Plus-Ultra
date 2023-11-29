require 'sidekiq/api'

class ISSidekiq

  def initialize 
  end

  # # Clear retry set
  def self.clear_retry_set
    Sidekiq::RetrySet.new.clear
  end
  
  # Clear scheduled jobs 
  def self.clear_scheduled_jobs
    Sidekiq::ScheduledSet.new.clear
  end
  
  # Clear 'Dead' jobs statistics
  def self.clear_dead_jobs
    Sidekiq::DeadSet.new.clear
  end
  
  # Clear 'Processed' and 'Failed' jobs statistics
  def self.clear_stats
    Sidekiq::Stats.new.reset
  end
  
  def self.queues 
    stats = Sidekiq::Stats.new
    stats.queues
  end
  
  # Clear all queues
  def self.clear_all_queues
    Sidekiq::Queue.all.map(&:clear)
  end
  
  # Clear specific queue
  def self.clear_queue(queue)
    queue = Sidekiq::Queue.new(queue)
    queue.count
    queue.clear
  end

end
  