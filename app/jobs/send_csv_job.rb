class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, input, sales_channel_id)
    UserMailer.csv_upload(email, title_team_player, input, sales_channel_id).deliver_now
  end
end
