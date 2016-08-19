class Tag < ApplicationRecord
  has_many :clothing_tags, dependent: :destroy
  has_and_belongs_to_many :clothing, join_table: :clothing_tags
end
