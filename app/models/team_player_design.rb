class TeamPlayerDesign < ApplicationRecord
  belongs_to :team_player
  has_one :team, through: :team_player
  validates_presence_of :team_player_id, :name, :artist
  validates_uniqueness_of :team_player_id, scope: [:name, :artist]
  before_validation(on: :create) { set_sku }

  def self.search_fields
    [:team_player_id, :name, :artist]
  end

  def readable_sku
    sku.to_s.rjust(2,'0')
  end

  private

  def set_sku
    if artist && name
      reserved_designs = ReservedDesign.where(artist: artist)
      reserved_designs.each do |reserved_design|
        if name.include?(reserved_design.snippet)
          self.sku = reserved_design.design_sku and return
        end
      end
    end

    available_skus = (1...ENV['MINIMUM_SKU'].to_i).to_a
    used_skus = TeamPlayerDesign.unscoped.where(team_player: self.team_player).pluck(:sku)
    self.sku = (available_skus - used_skus).first
  end
end
