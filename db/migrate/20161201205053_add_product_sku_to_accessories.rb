class AddProductSkuToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :product_sku, :string
  end
end
