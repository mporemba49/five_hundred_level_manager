class RemovePriceAndWeightFromAccessory < ActiveRecord::Migration[5.0]
  def change
    remove_column :accessories, :price
    remove_column :accessories, :weight
    remove_column :accessories, :sizes
  end
end
