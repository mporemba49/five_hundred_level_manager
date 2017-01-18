class CreateInventoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_items do |t|
       t.string   :full_sku, null: false, unique: true
       t.string   :team_player_design_id, null: false
       t.integer  :team_player_id, null: false
       t.string   :size_id, null: false
       t.string   :color_id, null: false
       t.integer  :quantity, default: 1
       t.timestamps

    end
  end
end