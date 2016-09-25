class AddOrdinalToSizes < ActiveRecord::Migration[5.0]
  def change
    add_column :sizes, :ordinal, :integer
    add_index :sizes, [:is_kids, :ordinal]
    remove_index :sizes, :is_kids
  end
end
