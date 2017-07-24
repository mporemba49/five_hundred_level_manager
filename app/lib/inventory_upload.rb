require 'csv'
require 'open-uri'

CHANNEL = "SH"
CLOTHING_SKU = "C"
HEADERS = ["SKU", "Player", "Design", "Team", "Apparel", "Style Size", "Color", "Location"]

class InventoryUpload
  def self.call(file_path)
    columns = [:full_sku, :team_player_design_id, :team_player_id, :size_id, :color_id, :producible_id, :producible_type, :location, :product]
    bulk_upload_path = Downloader.call(file_path)
    lines = CSV.read(bulk_upload_path, encoding: 'iso-8859-1')
    lines.shift
    values = []
    incomplete_values = []
    incomplete_values << HEADERS
    lines.each do |line|
      if line[0]
        value = []
        value << line[0]
        team = Team.where(id: line[0].slice(15..18).to_i).first
        player = team.team_players.where(sku: line[0].slice(20..22)).first
        design = TeamPlayerDesign.where(sku: line[0].slice(24..25).to_i, team_player_id: player.id).first
        color = Color.where(sku: line[0].slice(8..10)).first
        size = Size.where(sku: line[0].slice(3..4)).first
        value << design.id
        value << player.id
        value << size.id
        value << color.id
        item = Accessory.unscoped.where(sku: line[0].slice(5..7)).first || Clothing.unscoped.where(sku: line[0].slice(5..7)).first
        value << item.id
        value << item.class.name
        line[8] ? value << line[8] : value << "N/A"
        value << item.style
        value.include?(nil) ? incomplete_values << line : values << value
      else
        unless line[1...7].include?(nil)
          team = Team.where(name: line[3], league: line[4]).first
          if team
            player = team.team_players.find_by_player(line[1])
          else
            player = nil
          end
          design = TeamPlayerDesign.where(name: line[2].downcase).first
          size = Size.where(name: line[6].upcase).first
          color = Color.where(name: line[7]).first
          item = Accessory.unscoped.where(style: line[5]).first || Clothing.unscoped.where(style: line[5]).first
          if [player, design, size, color, item].include?(nil)
            incomplete_values << line
          else
            royalty = Royalty.where(league: player.team.league).first
            full_sku = 
                      [ 
                        ENV['UPLOAD_VERSION'],
                        CLOTHING_SKU + size.sku + item.sku + color.sku,
                        "XX",
                        player.team.id_string,
                        player.sku,
                        design.readable_sku,
                        royalty.code + CHANNEL
                      ].join("-")

            value = []
            value << full_sku
            value << design.id
            value << player.id
            value << size.id
            value << color.id
            value << item.id
            value << item.class.name
            line[8] ? value << line[8] : value << "N/A"
            value << item.style
            value.include?(nil) ? incomplete_values << line : values << value
          end
        end
      end
    end
    Rails.logger.info values

    InventoryItem.import(columns, values, validate: false, on_duplicate_key_ignore: true)

    Rails.logger.info incomplete_values
    
    S3Uploader.upload_incomplete(incomplete_values) unless incomplete_values.empty?
  
  end
end