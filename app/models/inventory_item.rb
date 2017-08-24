class InventoryItem < ApplicationRecord
  belongs_to :team_player_design
  belongs_to :team_player
  belongs_to :size
  belongs_to :color
  belongs_to :producible, -> { unscope(:where) }, polymorphic: true

  attr_accessor :bulk_csv
  validates_presence_of :full_sku
  validates_uniqueness_of :full_sku
  acts_as_paranoid

  def build_entry
    row = { 'Title' => team_player_design.name, 'Team' => team_player.team.name, 'Player' => team_player.player, 'League' => team_player.team.league, 'City' => team_player.team.city, 'Artist' => team_player_design.artist }
    InputEntry.new(row)
  end

end
