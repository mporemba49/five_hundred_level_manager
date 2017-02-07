class DenormalizeInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :design,   :string
    add_column :inventory_items, :product,  :string
    add_column :inventory_items, :team,     :string
    add_column :inventory_items, :player,   :string
    add_column :inventory_items, :league,   :string
    add_column :inventory_items, :artist,   :string
  end
end
