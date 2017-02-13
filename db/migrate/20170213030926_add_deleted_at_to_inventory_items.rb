class AddDeletedAtToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :deleted_at, :timestamp
  end
end
