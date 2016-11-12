class CreateAccessories < ActiveRecord::Migration[5.0]
  def change
    create_table :accessories do |t|
      t.string :base_name, null: false, unique: true
      t.string :style, null: false
      t.integer :price, null: false
      t.text    :sizes, array: true, default: [], null: false
      t.integer :weight, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end

    add_index :accessories, :base_name, unique: true
    add_index :accessories, :active
  end
end
