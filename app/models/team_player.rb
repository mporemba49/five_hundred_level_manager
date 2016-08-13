class TeamPlayer < ApplicationRecord
  belongs_to :team
  validates_presence_of :team, :player, :sku
  validates_uniqueness_of :team, scope: [:sku]

  before_create :generate_sku

  def to_s
    player
  end

  private

  def generate_sku
    until self.valid?
      self.sku = TeamPlayer.where(team: self.team).pluck(:sku).last.next
    end
  end
end
