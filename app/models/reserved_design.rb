class ReservedDesign < ApplicationRecord
  validates_presence_of :artist, :snippet
  before_create :generate_sku
  before_validate :standardize_fields

  private

  def standardize_fields
    self.artist = self.artist.downcase
    self.snippet = self.snippet.downcase
  end

  def generate_sku
    unless design_sku  
      self.design_sku = ReservedDesign.pluck(:sku).last.next
    end
  end
end
