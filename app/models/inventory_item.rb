class InventoryItem < ApplicationRecord
  belongs_to :team_player_design
  belongs_to :team_player
  belongs_to :size
  belongs_to :color
  belongs_to :producible, -> { unscope(where: :active) }, polymorphic: true

  attr_accessor :bulk_csv
  validates_presence_of :full_sku
  validates_uniqueness_of :full_sku
  acts_as_paranoid

  def build_entry
    return false unless check_data
    row = { 'Title' => team_player_design.name.split.map(&:capitalize).join(' '), 'Team' => team_player.team.name, 'Player' => team_player.player, 'League' => team_player.team.league, 'City' => team_player.team.city, 'Artist' => team_player_design.artist.split.map(&:capitalize).join(' ') }
    InputEntry.new(row)
  end

  def check_data
    return false if team_player_design == nil || team_player == nil || size == nil || color == nil || producible == nil
    true
  end

  def self.build_leagues_and_teams(items)
    leagues_and_teams = []
    items.each do |item|
      if item.team_player != nil && item.team_player.team != nil
        leagues_and_teams  <<  [item.team_player.team.league, item.team_player.team.name]
      end
    end
    leagues_and_teams.uniq!
    leagues_and_teams
  end

end
