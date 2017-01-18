class AddIndexToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_index :inventory_items, :full_sku, unique: true
  end
end
