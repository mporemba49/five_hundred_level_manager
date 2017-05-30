class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, sales_channel_ids)
    title_team_player_path = Downloader.call(title_team_player)
    csv_lines, @missing_files = GenerateCsv.call(title_team_player_path, sales_channel_ids.first)
    sales_channel_id = sales_channel_ids.shift
    UserMailer.csv_upload(email, csv_lines, sales_channel_id).deliver_now
    if csv_lines
      sales_channel_ids.each do |channel_id|
        channel = SalesChannel.find_by_id(channel_id)
        csv_lines.each do |line|
          line[13].chop!.chop!
          line[13] = line[13] + channel.sku
          csv << line
        end
        UserMailer.csv_upload(email, csv_lines, @missing_files sales_channel_id).deliver_now
      end
    end
    Validator.reset
  end
end
