class CreateAccessoryColors < ActiveRecord::Migration[5.0]
  def change
    create_table :accessory_colors do |t|
      t.integer :accessory_id, null: false
      t.integer :color_id, null: false
      t.string  :image, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :accessory_colors, [:accessory_id, :color_id], unique: true
    add_index :accessory_colors, :active
  end
end
