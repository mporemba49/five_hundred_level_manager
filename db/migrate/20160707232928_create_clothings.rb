class CreateClothings < ActiveRecord::Migration[5.0]
  def change
    create_table :clothings do |t|
      t.integer :version, null: false
      t.string :base_name, null: false
      t.string :type, null: false
      t.string :style, null: false
      t.string :gender, null: false
      t.integer :price, null: false
      t.text    :sizes, array: true, default: [], null: false
      t.integer :weight, null: false
      t.string  :handle_extension, null: false
      t.timestamps
    end

    add_index :clothings, :type
    add_index :clothings, :version
  end
end
