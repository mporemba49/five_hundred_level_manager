class RemoveSizesFromClothing < ActiveRecord::Migration[5.0]
  def change
    remove_column :clothings, :sizes
  end
end
