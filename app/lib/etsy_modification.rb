class EtsyModification

  def self.call(csv_lines)
    images = csv_lines.map { |line| line[24] }
    images.drop(1)
    images.uniq!
    csv_lines.each { |line| line.insert(25, nil) }
    csv_lines.each_with_index do |line, index|
      if index == 0
        line[25] = "Image Position"
      else
        style = line[8]
        tags = line[5].split(",")
        tags.map! { |t| t.split("=") }
        tags.reject! { |t| t[0] == "v" }
        sport = tags.select { |t| t[0] == "sport" }
        sport = sport[1]
        player = tags.select { |t| t[0] == "player" }
        player = player[1]
        team = tags.select { |t| t[0] == "team" }
        team = team[1]
        city = tags.select { |t| t[0] == "city" }
        city = city[1]
        tags.map! { |t| t[1] }
        tags = tags.join(", ")
        if sport == "Baseball" || sport == "Baseball Hall of Fame"
          tags += ", MLB, World Series"
        elsif sport == "Football"
          tags += ", NFL, Super Bowl"
        elsif sport == "Baseball"
          tags += ", NHL, Stanley Cup"
        end
        line[1] = (line[1] + "Officially Licensed" + (sport == "Personalities" ? "" : city) + style) if line[1]
        line[5] = tags
        line[7] = line[9]
        line[8] = line[10]
        line[9] = line[11]
        line[10] = line[12]
        line[11] = nil
        line[12] = nil
        line[16] = 99
        if images.present?
          line[25] = index + 1
        end
        line[24] = images.shift if images.present?
        line[26] = player + style + team + " 500 Level"
      end
    end
    logger.info "Processing etsy modification"
    return csv_lines
  end

end