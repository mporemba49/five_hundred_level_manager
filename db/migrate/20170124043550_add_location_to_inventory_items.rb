class AddLocationToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :location, :string
  end
end
