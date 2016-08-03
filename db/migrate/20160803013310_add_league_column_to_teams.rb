class AddLeagueColumnToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :league, :string
    add_index :teams, :league
  end
end
