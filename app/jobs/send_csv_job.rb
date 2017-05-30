class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, sales_channel_ids)
    UserMailer.csv_upload(email, title_team_player, sales_channel_ids).deliver_now
    Validator.reset
  end
end
