class PagesController < ApplicationController
  def create_csv
    if !params[:title_team_player].blank? && !params[:input].blank?
      SendCsvJob.perform_later(User.find(session[:user_id]).email, params[:title_team_player].path, params[:input].path)
      flash[:notice] = "An email with CSV attached will be sent soon"
    else
      flash[:error] = "Input File and TitleTeamPlayer File Required"
    end
    redirect_to clothing_index_path
  end
end
