class AddOptionsToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :option_one, :string
    add_column :accessories, :option_two, :string
    add_column :accessories, :option_three, :string
  end
end
