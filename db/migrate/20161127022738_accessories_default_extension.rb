class AccessoriesDefaultExtension < ActiveRecord::Migration[5.0]
  def change
    change_column :accessories, :extension, :string, default: ""
  end
end
