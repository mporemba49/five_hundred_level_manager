class CreateTeamPlayerDesigns < ActiveRecord::Migration[5.0]
  def change
    create_table :team_player_designs do |t|
      t.integer :team_player_id, null: false
      t.string :artist, null: false
      t.string :name, null: false
      t.integer :sku, null: false, default: 1

      t.timestamps
    end

    add_index :team_player_designs, [:team_player_id, :artist, :name], unique: true, name: 'team_player_lookup'
    add_index :team_player_designs, [:team_player_id, :sku], unique: true
  end
end
