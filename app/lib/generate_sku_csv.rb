require 'csv'

class GenerateSkuCsv
  CHANNEL = "SH"
  HEADER = ["Full SKU", "Design", "Team", "Player", "League", "Artist", "Size", "Color"]
  CLOTHING_SKU = "C"

  def self.call
    output_csv_lines = [HEADER]
    royalties = Royalty.all.to_a
    clothings = Clothing.unscoped.all.includes(clothing_colors: [:color], clothing_sizes: [:size])
    accessories = Accessory.unscoped.all.includes(accessory_colors: [:color], accessory_sizes: [:size])
    players = TeamPlayer.pluck(:id, :team_id, :sku, :player)
    path = "/tmp/#{ENV['BUCKET_NAME']}sku_file-#{Time.now.to_i}.csv"
    File.new(path, "w")
    CSV.open(path, "wb") do |csv|
      TeamPlayer.includes(:designs, :team).find_each(batch_size: 50) do |player|
        royalty = royalties.select { |royalty| royalty.league == player.team.league }.first
        next unless royalty
        designs = player.designs
        designs.each do |design|
          clothings.each do |clothing|
            clothing.sizes.each do |size|
              clothing.colors.each do |color|
                full_sku = 
                  [ 
                    ENV['UPLOAD_VERSION'],
                    CLOTHING_SKU + size.sku + clothing.sku + color.sku,
                    "XX",
                    player.team.id_string,
                    player.sku,
                    design.readable_sku,
                    royalty.code + CHANNEL
                  ].join("-")
                line = [full_sku, design.name, player.team.name, player.player, player.team.league, design.artist, size.name, color.name]
                csv << line
              end
            end
          end
          accessories.each do |accessory|
            accessory.sizes.each do |size|
              accessory.colors.each do |color|
                full_sku =
                  [ 
                    ENV['UPLOAD_VERSION'],
                    accessory.product_sku + size.sku + accessory.sku + color.sku,
                    "XX",
                    player.team.id_string,
                    player.sku,
                    design.readable_sku,
                    royalty.code + CHANNEL
                  ].join("-")
                line = [full_sku, design.name, player.team.name, player.player, player.team.league, design.artist, size.name, color.name]
                csv << line
              end
            end
          end
        end
      end
    end
    path
  end
end
