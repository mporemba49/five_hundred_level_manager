class TeamPlayerDesignsController < ApplicationController
  def index
    @team_player_designs = TeamPlayerDesign.includes(:team, :team_player)
      .order('teams.league, teams.name, team_players.player')
      .paginate(page: params[:page])
  end

  def destroy
    @team_player_design = TeamPlayerDesign.find(params[:id])
    if @team_player_design.destroy!
      flash[:notice] = 'Design Deleted'
    else
      flash[:error] = 'Design Not Deleted'
    end

    redirect_to team_player_designs_path
  end
end
