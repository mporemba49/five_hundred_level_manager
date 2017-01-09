require 'csv'

class GenerateSkuCsv
  CHANNEL = "SH"
  HEADER = ["Full SKU", "Design", "Team", "Player", "League", "Artist", "Size", "Color"]

  def self.call
    output_csv_lines = [HEADER]
    clothings = Clothing.unscoped.all.includes(clothing_colors: [:color], clothing_sizes: [:size])
    players = TeamPlayer.all.includes(:designs, :team)
    players.each do |player|
      royalty = Royalty.where(league: player.team.league).first
      designs = player.designs
      designs.each do |design|
        clothings.each do |clothing|
          colors = clothing.colors
          sizes = clothing.sizes
          sizes.each do |size|
            colors.each do |color|
              full_sku = 
                [ 
                  ENV['UPLOAD_VERSION'],
                  clothing.clothing_sku,
                  size.sku + clothing.sku + color.sku,
                  "XX",
                  player.team.id_string,
                  player.sku,
                  design.readable_sku,
                  royalty.code + CHANNEL
                ].join("-")
              line = [full_sku, design.name, player.team.name, player.player, player.team.league, design.artist, size.name, color.name]
              output_csv_lines << line
            end
          end
        end
        clothings = nil
        colors = nil
        sizes = nil
        GC.start
        accessories = Accessory.unscoped.all.includes(accessory_colors: [:color], accessory_sizes: [:size])
        accessories.each do |accessory|
          colors = accessory.colors
          sizes = accessory.sizes
          sizes.each do |size|
            colors.each do |color|
              full_sku =
                [ 
                  ENV['UPLOAD_VERSION'],
                  accessory.product_sku,
                  size.sku + accessory.sku + color.sku,
                  "XX",
                  player.team.id_string,
                  player.sku,
                  design.readable_sku,
                  royalty.code + CHANNEL
                ].join("-")
              line = [full_sku, design.name, player.team.name, player.player, player.team.league, design.artist, size.name, color.name]
              output_csv_lines << line
            end
          end
        end
      end
    end
    output_csv_lines
  end
end
