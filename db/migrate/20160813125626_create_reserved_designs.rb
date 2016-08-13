class CreateReservedDesigns < ActiveRecord::Migration[5.0]
  def change
    create_table :reserved_designs do |t|
      t.string :artist, null: false
      t.string :snippet, null: false
      t.integer :design_sku, null: false

      t.timestamps
    end

    add_index :reserved_designs, [:artist, :snippet], unique: true
  end
end
