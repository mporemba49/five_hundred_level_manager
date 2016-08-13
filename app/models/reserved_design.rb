class ReservedDesign < ApplicationRecord
  validates_presence_of :artist, :snippet
  before_create :generate_sku
  before_validation :standardize_fields
  validate :minimum_sku

  private

  def minimum_sku
    if design_sku && design_sku < ENV['MINIMUM_SKU'].to_i
      self.errors.add(:design_sku, "must be greater than or equal to #{ENV['MINIMUM_SKU']}")
    end
  end

  def standardize_fields
    self.artist = self.artist.downcase
    self.snippet = self.snippet.downcase
  end

  def generate_sku
    unless design_sku
      last_sku = ReservedDesign.pluck(:design_sku).last
      self.design_sku = last_sku.next
    end
  end
end
