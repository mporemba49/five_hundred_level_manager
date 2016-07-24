class PagesController < ApplicationController
  def create_csv
    if params[:title_team_player] && params[:input]
      csv_lines = GenerateCsv.call(params[:title_team_player], params[:input])
      if csv_lines
        returned_csv = CSV.generate(headers: true) do |csv|
          csv_lines.each do |line|
            csv << line
          end
        end
        send_data returned_csv, filename: "shopify_upload.csv"
      end
    else
      flash[:error] = "Input File and TitleTeamPlayer File Required"
      redirect_to clothing_index_path
    end
  end
end
