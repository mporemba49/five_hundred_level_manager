class CreateSizes < ActiveRecord::Migration[5.0]
  def change
    create_table :sizes do |t|
      t.string :name, null: false
      t.string :sku, null: false

      t.timestamps
    end

    create_table :clothing_sizes do |t|
      t.integer :clothing_id, null: false
      t.integer :size_id, null: false
    end

    add_index :sizes, :name, unique: true
    add_index :clothing_sizes, :clothing_id
    add_index :clothing_sizes, :size_id
  end
end
