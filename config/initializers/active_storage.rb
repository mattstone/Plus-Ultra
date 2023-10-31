
require File.join(__dir__, "../../app/previewers/heic_previewer.rb")


Rails.application.configure do
  config.active_storage.previewers << HeicPreviewer
  config.active_storage.variable_content_types << "image/heic"
  config.active_storage.variable_content_types << "image/heif"
end