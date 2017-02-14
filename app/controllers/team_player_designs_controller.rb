class TeamPlayerDesignsController < ApplicationController
  def index

    filter_q, filter_requests = filter_index(TeamPlayerDesign)
    @team_player_designs = TeamPlayerDesign.includes(:team, :team_player)
      .order('teams.league, teams.name, team_players.player')
      .where(filter_q, *filter_requests)
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

  def mass_delete
    @team_player_designs = TeamPlayerDesign.where(id: params['team_player_design_ids'])
    @size = @team_player_designs.size
    if @team_player_designs.delete_all
      flash[:notice] = "#{@size} Designs Deleted"
    else
      flash[:error] = 'Designs Not Deleted'
    end

    redirect_to team_player_designs_path
  end
end
