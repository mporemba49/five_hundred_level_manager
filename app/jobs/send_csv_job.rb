class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, input)
    UserMailer.csv_upload(email, title_team_player, input).deliver_now
  end
end
