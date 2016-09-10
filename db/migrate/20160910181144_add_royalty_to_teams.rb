class AddRoyaltyToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :royalty, :decimal, default: 0
  end
end
