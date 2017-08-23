class ChangeClothingPriceToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :clothings, :price, :decimal
  end
end
