class PagesController < ApplicationController
  def create_csv
    csv_lines = GenerateCsv.call(params[:title_team_player], params[:input])
    if csv_lines
      returned_csv = CSV.generate(headers: true) do |csv|
        csv_lines.each do |line|
          csv << line
        end
      end
      send_data returned_csv, filename: "shopify_upload.csv"
    end
  end
end
