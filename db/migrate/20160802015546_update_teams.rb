class UpdateTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :player_sku
    remove_column :teams, :team_sku
  end
end
