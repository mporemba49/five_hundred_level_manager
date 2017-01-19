class AddProducibleToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :producible_id, :integer
    add_column :inventory_items, :producible_type, :string
      
    add_index :inventory_items, [:producible_type, :producible_id]
  end
end
