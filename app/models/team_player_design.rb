class TeamPlayerDesign < ApplicationRecord
  belongs_to :team_player
  has_one :team, through: :team_player
  validates_presence_of :team_player_id, :name, :artist
  before_validation(on: :create) { set_sku }

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

    latest_sku = TeamPlayerDesign.unscoped.where(team_player: self.team_player)
                                 .where("sku < ?",  ENV['MINIMUM_SKU'].to_i)
                                 .pluck(:sku).last
    self.sku = latest_sku.next if latest_sku
  end
end
