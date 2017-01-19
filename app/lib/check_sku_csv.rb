require 'csv'

class CheckSkuCsv
  HEADER = ["Full SKU", "Design", "Team", "Player", "League", "Size", "Color"]

  def self.call(check_sku_path)
    output_lines = [HEADER]
    skus = []
    inventory_items = InventoryItem.all.includes(:team_player_design, :color, :size, team_player: [:team])
    CSV.foreach(check_sku_path, encoding: "ISO8859-1", headers: false) do |row|   
      skus << row[0]
    end
    skus.compact!
    skus.select! { |s| s.size > 25}
    skus.map! { |s| s.slice(0..-5)}
    inventory_items.each do |item|
      if skus.include?(item.full_sku.slice(0..-5))
        output_lines << [item.full_sku, item.team_player_design.name, item.team_player.team, item.team_player.player, item.team_player.team.league, item.size.name, item.color.name]
      end
    end
    output_lines
  end

end