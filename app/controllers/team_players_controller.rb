class TeamPlayersController < ApplicationController
  def index
    @team = Team.find(params[:team_id])
    @players = @team.team_players
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

  private

  def player_params
    params.require(:team_player).permit(:player, :sku)
  end
end