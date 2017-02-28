class AddBrandIdToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :brand_id, :integer
  end
end
