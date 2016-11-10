class Team < ApplicationRecord
  default_scope { order(:league, :name) }
  has_many :team_players, dependent: :destroy
  has_many :team_player_designs, through: :team_players

  def to_s
    name
  end

  def id_string
    id.to_s.rjust(4,'0')
  end
end
