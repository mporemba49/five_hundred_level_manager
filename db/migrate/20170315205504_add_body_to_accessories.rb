class AddBodyToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :body, :string
  end
end
