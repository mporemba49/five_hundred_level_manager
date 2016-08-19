class ClothingColor < ApplicationRecord
  belongs_to :clothing
  belongs_to :color

  def color_name
    color.name
  end
end
