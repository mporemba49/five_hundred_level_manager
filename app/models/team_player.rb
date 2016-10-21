class TeamPlayer < ApplicationRecord
  belongs_to :team
  has_many :designs, class_name: 'TeamPlayerDesign', dependent: :destroy
  validates_presence_of :team, :player, :sku
  validates_uniqueness_of :team, scope: [:sku]

  before_validation(on: :create) do
    latest_sku = TeamPlayer.unscoped.where(team: self.team).pluck(:sku).last
    self.sku = latest_sku.next if latest_sku
  end

  def to_s
    player
  end

end
