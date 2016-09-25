class Size < ApplicationRecord
  has_many :clothing_sizes, dependent: :destroy
  has_and_belongs_to_many :clothing, join_table: :clothing_sizes
  validates_uniqueness_of :sku
  validates_uniqueness_of :is_kids, scope: [:ordinal], unless: Proc.new { |s| s.ordinal.blank? }

  scope :kids, -> { where(is_kids: true) }
  scope :adults, -> { where(is_kids: false) }
  default_scope { order(:is_kids, :ordinal) }

  def to_s
    name
  end
end
