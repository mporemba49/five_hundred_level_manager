class AddColumnsToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :accessory_type, :string
    add_column :accessories, :extension, :string
    add_column :accessories, :handle_extension, :string
    add_column :accessories, :gender, :string

    add_index :accessories, :accessory_type
  end
end
