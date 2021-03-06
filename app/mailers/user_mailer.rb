class UserMailer < ApplicationMailer
  def alert_error(email, error)
    @error = error
    mail(to: [email, "braden.mugg@gmail.com"], subject: "500 Level | Upload Error")
  end

  def csv_upload(email, csv_lines, missing_files, channel_id)
    @missing_files = missing_files
    channel = SalesChannel.find_by_id(channel_id)
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["#{channel.name}_upload.csv"] = returned_csv
    end
    mail(to: email, subject: "#{ENV['EMAIL_TITLE']} | #{channel.name} CSV Download")
  end

  def clearance_csv_upload(email, csv_lines, missing_files, channel_id)
    @missing_files = missing_files
    channel = SalesChannel.find_by_id(channel_id)
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["#{channel.name}_upload.csv"] = returned_csv
    end
    mail(to: email, subject: "#{ENV['EMAIL_TITLE']} | #{channel.name} Clearance CSV Download")
  end

  def sku_upload(email, check_sku)
    check_sku_path = Downloader.call(check_sku)
    csv_lines = CheckSkuCsv.call(check_sku_path)
    if csv_lines.size > 1
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["returned_items.csv"] = returned_csv
      mail(to: email, subject: "#{ENV['EMAIL_TITLE']} | Items In Inventory")
    else
      mail(to: email, subject: "#{ENV['EMAIL_TITLE']} | No Inventory Items Found")
    end
  end

end
