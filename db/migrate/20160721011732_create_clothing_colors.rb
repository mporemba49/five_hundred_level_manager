class CreateClothingColors < ActiveRecord::Migration[5.0]
  def change
    create_table :clothing_colors do |t|

      t.integer :clothing_id, null: false
      t.integer :color_id, null: false
      t.string  :image, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :clothing_colors, [:clothing_id, :color_id], unique: true
    add_index :clothing_colors, :active
  end
end
