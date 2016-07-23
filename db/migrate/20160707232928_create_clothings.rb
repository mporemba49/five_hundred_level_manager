class CreateClothings < ActiveRecord::Migration[5.0]
  def change
    create_table :clothings do |t|
      t.string :base_name, null: false, unique: true
      t.string :clothing_type, null: false, default: 'T-Shirt'
      t.string :style, null: false
      t.string :gender, null: false
      t.integer :price, null: false
      t.text    :sizes, array: true, default: [], null: false
      t.integer :weight, null: false
      t.string  :extension
      t.string  :handle_extension, null: false, default: ','
      t.boolean :active, default: true, null: false
      t.timestamps
    end

    add_index :clothings, :base_name, unique: true
    add_index :clothings, :clothing_type
    add_index :clothings, :active
  end
end
