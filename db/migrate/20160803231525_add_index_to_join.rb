class AddIndexToJoin < ActiveRecord::Migration[5.0]
  def change
    remove_index :clothing_sizes, :clothing_id
    add_index :clothing_sizes, [:clothing_id, :size_id], unique: true
  end
end
