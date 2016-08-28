class AddIsKidsToSizes < ActiveRecord::Migration[5.0]
  def change
    add_column :sizes, :is_kids, :boolean, default: false, null: false
    add_index :sizes, :is_kids
  end

end
