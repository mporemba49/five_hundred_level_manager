class AddBrandToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :brand, :string
  end
end
