
# Annoyingly, app/previewers are not loaded at this point..
# so let's help things along the way.
require File.join(__dir__, "../../app/previewers/heic_previewer.rb")

Rails.application.configure do
  config.active_storage.previewers << HeicPreviewer
  config.active_storage.variable_content_types << "image/heic"
  config.active_storage.variable_content_types << "image/heif"
end