class AccessoryColor < ApplicationRecord
  belongs_to :accessory
  belongs_to :color
  attr_accessor :mass_update

  def color_name
    color.name
  end
end
