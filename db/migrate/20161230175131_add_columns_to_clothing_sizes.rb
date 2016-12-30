class AddColumnsToClothingSizes < ActiveRecord::Migration[5.0]
  def change
    add_column :clothing_sizes, :weight, :integer
  end
end
