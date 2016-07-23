class Color < ApplicationRecord
  scope :active, -> { where(active: true) }
  has_and_belongs_to_many :clothing, join_table: :clothing_colors
end
