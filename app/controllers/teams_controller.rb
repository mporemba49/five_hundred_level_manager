class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(team_params)
      flash[:notice] = "Team Updated"
      redirect_to teams_path
    else
      flash[:error] = "Team Not Updated"
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      flash[:notice] = 'Team deleted'
    else
      flash[:error] = 'Team not deleted'
    end
    redirect_to teams_path
  end

  private

  def team_params
    params.require(:team).permit(:royalty, :league, :name)
  end
end
