class PdfDownloadJob < ApplicationJob
  queue_as :default

  def perform(urls, destination_path)
    ret = system("wkhtmltopdf -q -s Letter --dpi 300 #{urls.join(" ")} #{destination_path}")
    raise "Unable to generate PDF [Debug: #{$?}]" unless File.exists?(destination_path)
  end
end
