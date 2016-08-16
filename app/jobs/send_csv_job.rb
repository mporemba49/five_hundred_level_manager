class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, input, royalty_sku)
    UserMailer.csv_upload(email, title_team_player, input, royalty_sku).deliver_now
  end
end
