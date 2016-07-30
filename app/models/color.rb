class Color < ApplicationRecord
  default_scope { order(:name) }
  has_and_belongs_to_many :clothing, join_table: :clothing_colors
end
