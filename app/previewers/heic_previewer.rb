class HEICPreviewer < ActiveStorage::Previewer
  CONTENT_TYPE = 'image/heic'.freeze

  class << self
    def accept?(blob)
      blob.content_type == CONTENT_TYPE && vips_exists?
    end

    def vips_exists?
      return @vips_exists unless @vips_exists.nil?

      require "image_processing/vips"
      @vips_exists = Vips.at_least_libvips?(0, 0)
    rescue StandardError
      @vips_exists = false
    end
  end

  def preview
    download_blob_to_tempfile do |input|
      io = ImageProcessing::Vips.source(input).convert('png').call
      yield io: io, filename: "#{blob.filename.base}.png", content_type: 'image/png'
    end
  end
end