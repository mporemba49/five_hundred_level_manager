class AddSkuToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :sku, :string
  end
end
