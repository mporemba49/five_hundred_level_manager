require 'csv'

class CreateDesigns
  def self.call(title_team_player_path)
    league_team = []
    CSV.foreach(title_team_player_path, encoding: "ISO8859-1", headers: true) do |row|
      begin
        league_team << [row[3], row[1]]
        create_records(row)
      rescue
      end
    end
    league_team.uniq!
    puts 'league_team'
    puts league_team
    return league_team
  end

  def self.create_records(row)
    title = row[0].strip.downcase
    team = row[1].strip
    player = row[2].strip
    league = row[3].strip.upcase
    city = row[4].strip
    artist = row[5].strip.downcase

    team = create_team(team, league, city)
    team_player = create_team_player(team, player)
    create_design(team_player, title, artist)
  end

  def self.create_design(team_player, title, artist)
    TeamPlayerDesign.where(team_player: team_player,
                           artist: artist,
                           name: title).first_or_create
  end

  def self.create_team_player(team, player)
    team_player = TeamPlayer.where(team: team, player: player).first_or_initialize
    team_player.save if team_player.new_record?
    team_player
  end

  def self.create_team(team, league, city)
    team = Team.where(name: team, league: league).first_or_initialize
    team.city = city unless team.city == city
    team.id = Team.maximum(:id).next unless team.persisted?
    team.save if team.city_changed?
    team
  end
end
