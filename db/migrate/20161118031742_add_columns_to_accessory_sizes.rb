class AddColumnsToAccessorySizes < ActiveRecord::Migration[5.0]
  def change
    add_column :accessory_sizes, :price, :integer
    add_column :accessory_sizes, :weight, :integer
  end
end
