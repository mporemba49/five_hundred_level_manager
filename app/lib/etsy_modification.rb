class EtsyModification

  def self.call(csv_lines)
    master_images = []
    loop_array = []
    csv_lines.drop(1).each do |line| 
      if line[1] && loop_array.present?
        master_images << loop_array
        loop_array = []
        loop_array << line[24]
      else
        loop_array << line[24]
      end
    end
    if loop_array.present?
      master_images << loop_array
    end
    master_images.each { |array| array.uniq! }
    csv_lines.each { |line| line.insert(25, nil) }
    sport = nil; player = nil; team = nil; city = nil
    new_line_count = 0
    image_count = 1
    images = []
    csv_lines.each_with_index do |line, index|
      if index == 0
        line[25] = "Image Position"
      else
        style = line[8]
        if line[5]
          tags = line[5].split(",")
          tags.map! { |t| t.split("=") }
          sport = tags.select { |t| t[0] == "sport" }[0][1]
          player = tags.select { |t| t[0] == "player" }[0][1]
          team = tags.select { |t| t[0] == "team" }[0][1]
          city = tags.select { |t| t[0] == "city" }[0][1]
          style = tags.select { |t| t[0] == "style" }[0][1]
          tags.select! { |t| t[0] == "player" || t[0] == "team" }
          tags.map! { |t| t[1] || t[0] }
          tags = tags.join(", ")
          league = EtsyModification.find_league(sport)
          line[1] = "#{player} #{style} - #{city} #{league} " + line[1]
          line[5] = tags
          images = master_images[new_line_count]
          new_line_count += 1
          image_count = 1
        end
        line[7] = line[9]
        line[8] = line[10]
        line[9] = line[11]
        line[10] = line[12]
        line[11] = nil
        line[12] = nil
        line[16] = 99
        if images.present?
          line[25] = image_count
          line[24] = images.shift
          image_count += 1
          line[26] = player + " " + style + " " + team
          line[26] += " 500 Level" unless ENV['STORE_TITLE'] == "Nomadic Apparel"
        else
          line[24] = nil
          line[26] = nil
        end
      end
    end
    return csv_lines
  end

  def self.find_league(sport)
    case sport
    when "Wrestling"
      "Legends"
    when "Baseball Hall of Fame"
      "Baseball"
    else
      sport
    end
  end

end
