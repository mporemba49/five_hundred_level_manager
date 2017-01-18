class InventoryItem < ApplicationRecord
  belongs_to :team_player_design
  belongs_to :team_player
  belongs_to :size
  belongs_to :color
  validates_presence_of :full_sku
  validates_uniqueness_of :full_sku

end
