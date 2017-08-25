class ClearanceCsvJob < ApplicationJob
  queue_as :default

  def perform(email, inventory_item_ids)
    sales_channel_skus = ["SH"]
    csv_lines, @missing_files = GenerateClearanceCsv.call(inventory_item_ids, SalesChannel.find_by_sku(sales_channel_skus).id)
    csv_lines = ClearanceModification.call(csv_lines)
    sales_channel_sku = sales_channel_skus.shift
    if sales_channel_sku == "ET"
      etsy_lines = EtsyModification.call(csv_lines)
      UserMailer.clearance_csv_upload(email, etsy_lines, @missing_files, SalesChannel.find_by_sku(sales_channel_sku).id).deliver_now
    else
      UserMailer.clearance_csv_upload(email, csv_lines, @missing_files, SalesChannel.find_by_sku(sales_channel_sku).id).deliver_now
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
          UserMailer.clearance_csv_upload(email, etsy_lines, @missing_files, channel.id).deliver_now
        else
          logger.info "Not Etsy"
          UserMailer.clearance_csv_upload(email, csv_lines, @missing_files, channel.id).deliver_now
        end
      end
    end
  end

end
