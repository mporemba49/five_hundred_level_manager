class CreateTeamPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :team_players do |t|
      t.integer :team_id, null: false
      t.string :player, null: false
      t.string :sku, null: false, default: "001"

      t.timestamps
    end

    add_index :team_players, [:team_id, :sku], unique: true
    add_index :team_players, [:team_id, :player], unique: true
  end
end
