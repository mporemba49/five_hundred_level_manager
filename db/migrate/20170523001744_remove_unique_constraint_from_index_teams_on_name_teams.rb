class RemoveUniqueConstraintFromIndexTeamsOnNameTeams < ActiveRecord::Migration[5.0]
  def change
    remove_index :teams, :name
    remove_index :teams, :league
    add_index :teams, [:name, :league], unique: true
  end
end
