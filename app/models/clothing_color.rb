class ClothingColor < ApplicationRecord
  belongs_to :clothing, dependent: :destroy
  belongs_to :color, dependent: :destroy

  def color_name
    color.name
  end
end
