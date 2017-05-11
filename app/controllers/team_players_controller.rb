class TeamPlayersController < ApplicationController
  def index
    @team = Team.find(params[:team_id])
    @players = @team.team_players
  end

  def show
    @player = TeamPlayer.find(params[:id])
    @designs = @player.designs
  end

  def edit
    @player = TeamPlayer.find(params[:id])
  end

  def update
    @player = TeamPlayer.find(params[:id])
    if @player.update_attributes(player_params)
      @team = @player.team
      flash[:notice] = "Player Updated"
      redirect_to team_team_players_path(@team)
    else
      flash[:error] = "Player Not Updated"
      render :edit
    end
  end

  def destroy
    @player = TeamPlayer.find(params[:id])
    @team = @player.team
    if @player.destroy
      flash[:notice] = 'Player deleted'
    else
      flash[:error] = 'Player not deleted'
    end
    redirect_to team_team_players_path(@team)
  end

  def mass_delete
    @team_players = TeamPlayer.where(id: params['team_player_ids'])
    @team = @team_players.first.team
    @size = @team_players.size
    if @team_players.delete_all
      flash[:notice] = "#{@size} Players Deleted"
    else
      flash[:error] = 'Players Not Deleted'
    end
    redirect_to team_team_players_path(@team)
  end

  private

  def player_params
    params.require(:team_player).permit(:player, :sku)
  end
end