class BuildSkuCsvJob < ApplicationJob
  queue_as :default

  def perform(email)
    UserMailer.sku_csv(email).deliver_now
  end
end