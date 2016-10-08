require 'rails_helper'

describe CreateDesigns do
  describe ".call" do
    it "finds/creates a team for each row" do
      expect{
        CreateDesigns.call("spec/fixtures/title_team_player.csv") 
      }.to change{ Team.count }.by(1)
      expect(Team.where(name: 'Minnesota Vikings').first).not_to be_nil
    end

    it "finds/creates a team_player for each row" do
      expect{
        CreateDesigns.call("spec/fixtures/title_team_player.csv") 
      }.to change{ TeamPlayer.count }.by(2)
      expect(TeamPlayer.where(player: 'Matt Asiata').first).not_to be_nil
      # Second player has umlaut in name, so it's saved as \u009
      # Better to only check that the player was created
    end

    it "finds/creates a team_player_design for each row" do
      expect{
        CreateDesigns.call("spec/fixtures/title_team_player.csv") 
      }.to change{ TeamPlayerDesign.count }.by(3)
      expect(TeamPlayerDesign.where(name: 'matt asiata football p').first).not_to be_nil
    end
  end
end
