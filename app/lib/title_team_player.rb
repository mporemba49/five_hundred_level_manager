class TitleTeamPlayer
  attr_reader :title, :team, :player, :league

  def initialize(row)
    @title = row[0].strip
    @team = row[1].strip
    @player = row[2].strip
    @league = row[3].strip if row[3]
  end
end
