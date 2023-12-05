class ISQRCode
  
  def self.generate_as_png(url)
    require 'barby'
    require 'barby/barcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'

    qr_code       = Barby::QrCode.new(url, level: :q, size: 10)
    base64_output = Base64.encode64(qr_code.to_png({ xdim: 5 }))
    "data:image/png;base64,#{base64_output}"
  end
  
end