class CheckSkuJob < ApplicationJob
  queue_as :default

  def perform(email, check_sku)
    UserMailer.sku_upload(email, check_sku).deliver_now
  end
end