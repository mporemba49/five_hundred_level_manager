require 'csv'

class GenerateSkuCsv
  CHANNEL = "SH"
  HEADER = ["Full SKU", "Design", "Team", "Player", "League", "Artist", "Size", "Color"]
  CLOTHING_SKU = "C"

  def self.call
    output_csv_lines = [HEADER]
    clothings = Clothing.unscoped.pluck(:id, :sku)
    clothings.each do |clothing|
      sizes = Size.joins(:clothing_sizes).where(clothing_sizes: {clothing_id: clothing[0]}).pluck(:'sizes.sku', :'sizes.name')
      clothing << sizes
      colors = Color.joins(:clothing_colors).where(clothing_colors: {clothing_id: clothing[0]}).pluck(:'colors.sku', :'colors.name')
      clothing << colors
    end
    players = TeamPlayer.pluck(:id, :team_id, :sku, :player)
    players.each do |player|
      team = Team.where(id: player[1]).pluck(:id, :league, :name)
      player << team
      designs = TeamPlayerDesign.where(team_player_id: player[0]).pluck(:sku, :name, :artist)
      player << designs
    end
    royalties = Royalty.all.to_a
    players.each do |player|
      royalty = royalties.select { |royalty| royalty.league == player[4][0][1] }
      designs = player[5]
      designs.each do |design|
        clothings.each do |clothing|
          colors = clothing[3]
          sizes = clothing[2]
          sizes.each do |size|
            colors.each do |color|
              full_sku = 
                [ 
                  ENV['UPLOAD_VERSION'],
                  CLOTHING_SKU,
                  size[1] + clothing[1] + color[0],
                  "XX",
                  player[4][0][0].to_s.rjust(4,'0'),
                  player[2],
                  design[0][0].to_s.rjust(2,'0'),
                  royalty[0].code + CHANNEL
                ].join("-")
              line = [full_sku, design[0][1], player[0][4][0][2], player[3], player[0][4][0][1], players[0][5][0][2], size[0], color[1]]
              output_csv_lines << line
            end
          end
        end
      end
    end
    clothings = nil
    colors = nil
    sizes = nil
    GC.start
    accessories = Accessory.unscoped.pluck(:id, :sku, :product_sku)
    accessories.each do |accessory|
      sizes = Size.joins(:accessory_sizes).where(accessory_sizes: {accessory_id: accessory[0]}).pluck(:'sizes.sku', :'sizes.name')
      accessory << sizes
      colors = Color.joins(:accessory_colors).where(accessory_colors: {accessory_id: accessory[0]}).pluck(:'colors.sku', :'colors.name')
      accessory << colors
    end
    players.each do |player|
      royalty = royalties.select { |royalty| royalty.league == player[4][0][1] }
      designs = player[5]
      designs.each do |design|
        accessories.each do |accessory|
          colors = accessory[4]
          sizes = accessory[3]
          sizes.each do |size|
            colors.each do |color|
              full_sku =
                [ 
                  ENV['UPLOAD_VERSION'],
                  accessory[2],
                  size[1] + accessory[1] + color[0],
                  "XX",
                  player[4][0][0].to_s.rjust(4,'0'),
                  player[2],
                  design[0][0].to_s.rjust(2,'0'),
                  royalty[0].code + CHANNEL
                ].join("-")
              line = [full_sku, design[0][1], player[0][4][0][2], player[3], player[0][4][0][1], players[0][5][0][2], size[0], color[1]]
              output_csv_lines << line
            end
          end
        end
      end
    end
    output_csv_lines
  end
end
