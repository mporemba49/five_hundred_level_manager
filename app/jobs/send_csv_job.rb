class SendCsvJob < ApplicationJob
  queue_as :default

  def perform(email, title_team_player, sales_channel_skus)
    title_team_player_path = Downloader.call(title_team_player)
    if sales_channel_skus.include?("ET")
      etsy_index = sales_channel_skus.index("ET")
      last_index = sales_channel_skus.size - 1
      sales_channel_skus.insert(last_index, sales_channel_skus.delete_at(etsy_index))
    end
    csv_lines, @missing_files = GenerateCsv.call(title_team_player_path, SalesChannel.find_by_sku(sales_channel_sku).id)
    sales_channel_sku = sales_channel_skus.shift
    if sales_channel_sku == "ET"
      etsy_lines = EtsyModification.call(csv_lines)
      UserMailer.csv_upload(email, etsy_lines, @missing_files, SalesChannel.find_by_sku(sales_channel_sku).id).deliver_now
    else
      UserMailer.csv_upload(email, csv_lines, @missing_files, SalesChannel.find_by_sku(sales_channel_sku).id).deliver_now
    end
    if csv_lines
      sales_channel_skus.each do |channel_sku|
        channel = SalesChannel.find_by_sku(channel_sku)
        csv_lines.drop(1).each do |line|
          line[13].chop!.chop!
          line[13] = line[13] + channel.sku
        end
        if channel_sku == "ET"
          etsy_lines = EtsyModification.call(csv_lines)
          logger.info "Etsy"
          UserMailer.csv_upload(email, etsy_lines, @missing_files, channel.id).deliver_now
        else
          logger.info "Not Etsy"
          UserMailer.csv_upload(email, csv_lines, @missing_files, channel.id).deliver_now
        end
      end
    end
    Validator.reset
  end
end
