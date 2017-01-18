require 'csv'

class InventoryUpload
  def self.call()
    columns = [:full_sku, :team_player_design_id, :team_player_id, :size_id, :color_id]
    lines = CSV.read("#{Rails.root}/tmp/500-level-testsku_file-1484282313.csv")
    lines.shift
    values = []
    incomplete_values = []
    lines.each do |line|
      if line.include?(nil)
        incomplete_values << line
      else
        value = []
        value << line[0]
        value << TeamPlayerDesign.where(sku: line[0].split('-')[6].to_i, team_player_id: line[0].split('-')[5].to_i).first.id
        value << TeamPlayer.where(player: line[3]).first.id
        value << Size.where(name: line[6]).first.id
        value << Color.where(name: line[7]).first.id
        values << value
      end
    end

    InventoryItem.import(columns, values, validate: false)

    
    S3Uploader.upload_incomplete(incomplete_values) unless incomplete_values.empty?
  
  end
end