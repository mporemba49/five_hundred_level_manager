class Color < ApplicationRecord
  default_scope { order(:name) }
  has_many :clothing_colors, dependent: :destroy
  has_and_belongs_to_many :clothing, join_table: :clothing_colors
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :sku, blank: true

  before_validation :format

  private

  def format
    self.name = name.capitalize
    self.sku = sku.upcase
  end
end
