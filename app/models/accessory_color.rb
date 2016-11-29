class AccessoryColor < ApplicationRecord
  belongs_to :accessory
  belongs_to :color

  def color_name
    color.name
  end
end
