class TeamPlayerDesign < ApplicationRecord
  belongs_to :team_player
  validates_presence_of :team_player_id, :name, :artist
  before_create :set_sku

  private

  def set_sku
    until self.valid?
      self.sku = TeamPlayerDesign.where(team_player: self.team_player).where("sku < 89").pluck(:sku).last.next
    end
  end
end
