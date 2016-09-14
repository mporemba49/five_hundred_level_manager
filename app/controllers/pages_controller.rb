class PagesController < ApplicationController
  def create_csv
    if !params[:title_team_player].blank?
      sales_channel_id = params[:sales_channel]
      uploaded_ttp_path = Uploader.call(params[:title_team_player].path)
      SendCsvJob.perform_later(User.find(session[:user_id]).email,
                               uploaded_ttp_path, sales_channel_id)
      flash[:notice] = "An email with CSV attached will be sent soon"
    else
      flash[:error] = "Input File and TitleTeamPlayer File Required"
    end
    redirect_to clothing_index_path
  end
end
