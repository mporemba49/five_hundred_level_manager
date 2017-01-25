require 'csv'
require 'open-uri'

CHANNEL = "SH"
CLOTHING_SKU = "C"
HEADERS = ["SKU", "Player", "Design", "Team", "Apparel", "Style Size", "Color", "Location"]

class InventoryUpload
  def self.call()
    url = "https://s3-us-west-2.amazonaws.com/500levelcsvs/returns_sample.csv"
    download = open(url)
    columns = [:full_sku, :team_player_design_id, :team_player_id, :size_id, :color_id, :producible_id, :producible_type, :location]
    lines = CSV.read(download, encoding: 'iso-8859-1')
    lines.shift
    values = []
    incomplete_values = []
    incomplete_values << HEADERS
    lines.each do |line|
      if line[0]
        value = []
        value << line[0]
        team = Team.where(id: line[0].split('-')[4].to_i).first
        value << TeamPlayerDesign.where(sku: line[0].split('-')[6].to_i, team_player_id: line[0].split('-')[5].to_i).first.id
        value << team.team_players.find_by_player(line[1]).id
        value << Color.where(sku: line[0].split('-')[2].slice(4..6)).first.id
        value << Size.where(sku: line[0].split('-')[2].slice(0)).first.id
        item = Accessory.unscoped.where(sku: line[0].split('-')[2].slice(1..3)).first || Clothing.unscoped.where(sku: line[0].split('-')[2].slice(1..3)).first
        value << item.id
        value << item.class.name
        value << line[7] || "N/A"
        value.include?(nil) ? incomplete_values << line : values << value
      else
        unless line[1...6].include?(nil)
          team = Team.where(name: line[3]).first
          if team
            player = team.team_players.find_by_player(line[1])
          else
            player = nil
          end
          design = TeamPlayerDesign.where(name: line[2].downcase).first
          size = Size.where(name: line[5].upcase).first
          color = Color.where(name: line[6]).first
          item = Accessory.unscoped.where(style: line[4]).first || Clothing.unscoped.where(style: line[4]).first
          if [player, design, size, color, item].include?(nil)
            incomplete_values << line
          else
            royalty = Royalty.where(league: player.team.league).first
            full_sku = 
                      [ 
                        ENV['UPLOAD_VERSION'],
                        CLOTHING_SKU,
                        size.sku + item.sku + color.sku,
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
            value << line[7] || "N/A"
            value.include?(nil) ? incomplete_values << line : values << value
          end
        end
      end
    end

    InventoryItem.import(columns, values, validate: false, on_duplicate_key_ignore: true)

    
    S3Uploader.upload_incomplete(incomplete_values) unless incomplete_values.empty?
  
  end
end