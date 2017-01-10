class Size < ApplicationRecord
  has_many :clothing_sizes, dependent: :destroy
  has_many :accessory_sizes, dependent: :destroy
  has_and_belongs_to_many :clothing, join_table: :clothing_sizes
  has_and_belongs_to_many :accessory, join_table: :accessory_sizes

  scope :kids, -> { where(is_kids: true) }
  scope :adults, -> { where(is_kids: false) }
  default_scope { order(:is_kids, :ordinal) }

  def to_s
    name
  end
end
