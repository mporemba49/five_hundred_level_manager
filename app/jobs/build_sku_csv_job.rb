class BuildSkuCsvJob < ApplicationJob
  queue_as :default

  def perform
    S3Uploader.sku_call
  end
end