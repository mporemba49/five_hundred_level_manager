require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist, :extension, :host_validator, :title_team_player

  def initialize(row, host_validator)
    @handle = row[0]
    @title = row[1].gsub("\"","").gsub("'","")
    @artist = row[3]
    @extension = ""
    @host_validator = host_validator
  end

  def url_string_for_product(product, image)
    search_sub_dirs.each do |sub_dir|
      test_url = product.image_url_builder(url_design, sub_dir, image)
      rootless_url = test_url.gsub(/.*\/#{league}/,league)
      rootless_url.gsub!("?a=b","")

      return URI.escape(test_url) if @host_validator.objects.select { |object| object.key == rootless_url }.any?
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

  def url_design
    return @url_design if @url_design 

    if host_validator.validate_folder(league + "/" + team + "/" + @title + "/")
      @url_design = ENV['IMAGE_ROOT'] + league + "/" + team + "/" + @title
      return @url_design 
    end

    if host_validator.validate_folder(league + "/" + team + "/" + @title + " (#{@artist})/")
      @url_design = ENV['IMAGE_ROOT'] + league + "/" + team + "/" + @title + " (#{@artist})"
      return @url_design
    end
  end

  def title_team_player
    @title_team_player ||= TITLE_TEAM_PLAYERS.select { |ttp| ttp.title == @title }.first
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
    set = TITLE_TEAM_PLAYERS.select { |a,b,c| a.title == title }.first
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

  def image_design_url_exists?
    return true if url_design
  end

  def products
    @products ||= if gender == "Mens"
      [
        MensHoodie.new(self),
        CrewSweatshirt.new(self),
        ZipHoodie.new(self),
        LaceHoodie.new(self),
        LongSleeve.new(self),
        MensTShirt.new(self),
        MensVNeck.new(self),
        MensTankTop.new(self),
        Onesie.new(self),
        ToddlerTShirt.new(self),
        YouthTShirt.new(self),
        YouthHoodie.new(self)
      ]
    else
      [
        WomensHoodie.new(self),
        ManiacSweatshirt.new(self),
        ScoopNeck.new(self),
        WomensTShirt.new(self),
        FineJerseyTShirt.new(self),
        WomensVNeck.new(self),
        WomenTankTop.new(self)
      ]
    end
  end

  def tags(product, published, first_line)
    if first_line
      title+",,#{artist},#{product.type},\"#{product.tags.unshift(player).uniq.join(',')}\",#{published},"
    else
      ",,,,,,"
    end
  end
end
