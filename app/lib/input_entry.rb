require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist, :extension, :title_team_player, :title_team_players

  def initialize(row, title_team_players)
    @title_team_players = title_team_players
    @handle = row[0]
    @title = row[1].gsub("\"","").gsub("'","")
    @artist = row[3]
    @extension = ""
  end

  def url_string_for_clothing(clothing, image)
    search_sub_dirs.each do |sub_dir|
      test_url = clothing.image_url_builder(url_design, sub_dir, image)
      rootless_url = test_url.gsub(/.*\/#{league}/,league)
      rootless_url.gsub!("?a=b","")

      return URI.escape(test_url) if Validator.objects.select { |object| object.key == rootless_url }.any?
    end

    return nil
  end

  def search_sub_dirs
    @search_sub_dirs ||= if gender == "Mens"
      ["","MEN","Men","Unisex","KIDS","Kids"]
    else
      ["women","WOMEN","Women","","Unisex","MEN","Men"]
    end
  end

  def default_folder
    league + "/" + team + "/" + @title + "/"
  end

  def folder_with_artist
    league + "/" + team + "/" + @title + " (#{@artist})/"
  end

  def url_design
    return @url_design if @url_design

    if Validator.valid_folder?(default_folder)
      @url_design = ENV['IMAGE_ROOT'] + league + "/" + team + "/" + @title
      return @url_design 
    end

    if Validator.valid_folder?(folder_with_artist)
      @url_design = ENV['IMAGE_ROOT'] + league + "/" + team + "/" + @title + " (#{@artist})"
      return @url_design
    end
  end

  def title_team_player
    @title_team_player ||= title_team_players.select { |ttp| ttp.title == @title }.first
  end

  def league
    return @league if @league

    @league = if title_team_player && title_team_player.league
      title_team_player.league 
    else
      STDERR.puts "No League for '#{@handle}'"
      ""
    end
  end

  def team
    return @team if @team
    # Check that there is a match for this design, else report ERR and return empty string
    @team = if title_team_player && title_team_player.team
      title_team_player.team 
    else
      STDERR.puts "No Team for '#{@handle}'"
      ""
    end
  end

  def player
    return @player if @player
    # Check that there is a match for this design, else report ERR and return empty string
    set = title_team_players.select { |a,b,c| a.title == title }.first
    if title_team_player && title_team_player.player
      @player = title_team_player.player
    else
      STDERR.puts "No Player for '#{handle}'"
      @player = ""
    end

    @player
  end

  def gender
    @gender ||= @handle[-2..-1] == "-1" ? "Womens" : "Mens"
  end

  def formatted_gender(gender)
    case gender
    when "Women"
      return "Women"
    when "Womens"
      return "Women"
    when "Mens"
      return "Men"
    when "Male"
      return "Men"
    when "Kids"
      return "Kids"
    end
  end

  def missing_image_design_url?
    !url_design
  end

  def missing_design_url_error
    "MISSING \"/#{league}/#{team}/#{title}#{extension}/\" "
  end

  def clothing
    @clothing ||= if gender == "Mens"
      Clothing.where(gender: ['Male', 'Kids']).includes(clothing_colors: [:color]).includes(:tags)
    else
      Clothing.where(gender: 'Women').includes(clothing_colors: [:color]).includes(:tags)
    end
  end

  def tags(clothing, published, first_line)
    if first_line
      item_tags = clothing.tags.map(&:name).unshift(player)
      item_tags << "player=#{player}"
      item_tags << "gender=#{clothing.gender}"
      item_tags << "style=#{clothing.style_tag}"
      item_tags = item_tags.uniq.join(',')

      [title, nil, artist, clothing.clothing_type, item_tags, published]
    else
      [nil,nil,nil,nil,nil,nil]
    end
  end
end
