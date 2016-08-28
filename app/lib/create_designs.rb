require 'csv'

class CreateDesigns
  def self.call(title_team_player_path)
    CSV.foreach(title_team_player_path, headers: true) do |row|
      begin
        create_records(row)
      rescue
      end
    end
  end

  def self.create_records(row)
    title = row[0].strip.downcase
    team = row[1].strip.titleize
    player = row[2].strip.titleize
    league = row[3].strip.upcase
    city = row[4].strip
    artist = row[5].strip.downcase

    team = create_team(team, league, city)
    team_player = create_team_player(team, player)
    create_design(team_player, title, artist)
  end

  def self.create_design(team_player, title, artist)
    TeamPlayerDesign.where(team_player: team_player, artist: artist, name: title).first_or_create
  end

  def self.create_team_player(team, player)
    team_player = TeamPlayer.where(team: team, player: player).first_or_initialize
    team_player.save if team_player.new_record?
    team_player
  end

  def self.create_team(team, league, city)
    team = Team.where(name: team, league: league).first_or_initialize
    team.update_attribute(:city, city) unless team.city == city
    team
  end
end
