class Size < ApplicationRecord
  has_and_belongs_to_many :clothing, join_table: :clothing_sizes
  validates_uniqueness_of :sku
end
