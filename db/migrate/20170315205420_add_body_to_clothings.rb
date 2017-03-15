class AddBodyToClothings < ActiveRecord::Migration[5.0]
  def change
    add_column :clothings, :body, :string
  end
end
