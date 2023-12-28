# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
#   config.active_storage.previewers << HeicPreviewer
#   config.active_storage.variable_content_types << "image/heic"
#   config.active_storage.variable_content_types << "image/heif"
    config.action_mailer.default_url_options = { :host => ENV['DOMAIN'] }
    config.cache_store = :solid_cache_store

    # Use a real queuing backend for Active Job (and separate queues per environment).
    config.active_job.queue_adapter = :solid_queue
    # config.active_job.queue_name_prefix = "starter_production"
end

