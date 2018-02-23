class AddCustomTagsToAccessories < ActiveRecord::Migration[5.0]
  def change
    add_column :accessories, :custom_tag, :string, default: ""
  end
end
