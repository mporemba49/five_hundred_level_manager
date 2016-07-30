class AddSkuColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :colors, :sku, :string
    add_column :clothings, :sku, :string
  end
end
