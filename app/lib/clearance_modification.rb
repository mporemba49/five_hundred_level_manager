require 'logger'

class ClearanceModification

  def self.call(csv_lines)
    csv_lines.drop(1).each do |line|
      Rails.logger.info(line) 
      line[0] += "-clearance"
      line[44] = line[1] + " Clearance"
      line[1] += " - Clearance"
      line[5] += ",Clearance"
      line[15] = "shopify"
      line[20] = line[19]
      line[19] = line[19] / 2
    end
    return csv_lines
  end

end