class UserMailer < ApplicationMailer
  def test
      mail(to: "nicholas.lee.3@gmail.com", subject: "Test")
  end

  def csv_upload(email, title_team_player, input)
    title_team_player_path = Downloader.call(title_team_player)
    input_path = Downloader.call(input)

    csv_lines = GenerateCsv.call(title_team_player_path, input_path)
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["shopify_upload.csv"] =  { mime_type: 'text/csv',
                                             content: returned_csv,
                                             content_disposition: 'attachment'}
      mail(to: email, subject: "CSV Download")
    end
  end
end
