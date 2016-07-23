class PagesController < ApplicationController
  def create_csv
    csv = GenerateCsv.call(params[:title_team_player], params[:input])
    redirect_to clothing_index_path
  end
end
