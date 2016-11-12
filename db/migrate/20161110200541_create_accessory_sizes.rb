class CreateAccessorySizes < ActiveRecord::Migration[5.0]
  def change
    create_table :accessory_sizes do |t|
      t.integer :accessory_id, null: false
      t.integer :size_id, null: false
    end

    add_index :accessory_sizes, :accessory_id
    add_index :accessory_sizes, :size_id
  end
end
