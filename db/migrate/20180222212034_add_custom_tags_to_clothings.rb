class AddCustomTagsToClothings < ActiveRecord::Migration[5.0]
  def change
    add_column :clothings, :custom_tag, :string, default: ""
  end
end
