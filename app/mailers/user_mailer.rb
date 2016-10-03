class UserMailer < ApplicationMailer
  def alert_error(email, error)
    @error = error
    mail(to: [email, "nicholas.lee.3@gmail.com"], subject: "500 Level | Upload Error")
  end

  def csv_upload(email, title_team_player, sales_channel_id)
    title_team_player_path = Downloader.call(title_team_player)

    csv_lines, @missing_files = GenerateCsv.call(title_team_player_path, sales_channel_id)
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["shopify_upload.csv"] =  returned_csv
    end

    mail(to: email, subject: "500 Level | CSV Download")
  end
end
