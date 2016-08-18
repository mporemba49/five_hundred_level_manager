class TeamPlayerDesignsController < ApplicationController
  def index
    @team_player_designs = TeamPlayerDesign.includes(:team, :team_player).order('teams.league, teams.name, team_players.player')
  end
end
