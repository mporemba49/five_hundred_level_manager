class DefaultExtension < ActiveRecord::Migration[5.0]
  def change
    change_column :clothings, :extension, :string, default: ""
  end
end
