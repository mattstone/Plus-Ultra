# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!


Rails.application.configure do
#   config.active_storage.previewers << HeicPreviewer
#   config.active_storage.variable_content_types << "image/heic"
#   config.active_storage.variable_content_types << "image/heif"
    config.action_mailer.default_url_options = { :host => ENV['DOMAIN'] }
end

