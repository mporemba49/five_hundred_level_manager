class ClothingTag < ApplicationRecord
  belongs_to :clothing, dependent: :destroy
  belongs_to :tag, dependent: :destroy
end
