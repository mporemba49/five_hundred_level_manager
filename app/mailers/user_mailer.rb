class UserMailer < ApplicationMailer
  def csv_upload(email, title_team_player, input)
    csv_lines = GenerateCsv.call(title_team_player, input)
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      attachments["shopify_upload.csv"] = returned_csv
      mail(to: email, subject: "CSV Download")
    end
  end
end
