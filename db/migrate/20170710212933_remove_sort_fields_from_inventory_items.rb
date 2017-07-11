class RemoveSortFieldsFromInventoryItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :inventory_items, :design,   :string
    remove_column :inventory_items, :team,     :string
    remove_column :inventory_items, :player,   :string
    remove_column :inventory_items, :league,   :string
    remove_column :inventory_items, :artist,   :string
  end
end
