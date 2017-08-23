class ChangeAccessorySizePriceToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :accessory_sizes, :price, :decimal
  end
end
