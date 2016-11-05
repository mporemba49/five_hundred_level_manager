class Royalty < ApplicationRecord
  validates_presence_of :code, :league
  validates_uniqueness_of :code, :league

  before_validation :set_fields

  private

  def set_fields
    self.code = code.upcase
  end
end
