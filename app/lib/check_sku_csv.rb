require 'csv'

class CheckSkuCsv
  HEADER = ["Full SKU", "Design", "Team", "Player", "League", "Artist", "Size", "Color"]

  def self.call(check_sku_path)
    output_lines = [HEADER]
    inventory_items = InventoryItem.all.includes(:team_player, :team_player_design, :color, :size)
    item_skus = inventory_items.map { |item| item.full_sku.slice(0..-5) }
    CSV.foreach(check_sku_path, encoding: "ISO8859-1", headers: true) do |row|
      if item_skus.include?(row["Full SKU"].slice(0..-5))
        output_lines << row
      end
    end
    output_lines
  end

end