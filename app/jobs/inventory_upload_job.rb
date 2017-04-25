class InventoryUploadJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    InventoryUpload.call(file_path)
  end
end