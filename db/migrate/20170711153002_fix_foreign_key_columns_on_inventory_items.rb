class FixForeignKeyColumnsOnInventoryItems < ActiveRecord::Migration[5.0]
  def change
    change_column :inventory_items, :team_player_design_id, 'integer USING CAST("team_player_design_id" AS integer)', null: false
    change_column :inventory_items, :size_id, 'integer USING CAST("size_id" AS integer)', null: false
    change_column :inventory_items, :color_id, 'integer USING CAST("color_id" AS integer)', null: false
  end
end
