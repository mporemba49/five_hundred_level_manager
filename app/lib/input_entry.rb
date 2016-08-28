require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist, :extension, :design

  FORMATTED_GENDER = { "Women" => "Women", "Womens" => "Women", "Mens" => "Men",
                       "Male" => "Men", "Kids" => "Kids" }
  LEAGUE_SPORT = { 'MLB' => 'Baseball', 'NFL' => 'Football', 'NBA' => 'Basketball', 'NHL' => 'Hockey' }

  def initialize(row)
    @handle = row[0]
    @title = row[1].gsub("\"","").gsub("'","")
    @artist = row[3]
    @extension = ""
    @design = TeamPlayerDesign.includes(team_player: [:team])
      .where(artist: @artist.downcase, name: @title.downcase).first
  end

  def url_string_for_clothing(clothing, image)
    search_sub_dirs.each do |sub_dir|
      test_url = clothing.image_url_builder(url_design, sub_dir, image)
      rootless_url = test_url.gsub(/.*\/#{league}/,league)
      matching_object = Validator.objects.select { |object| object.key.downcase == rootless_url.downcase }.first

      if matching_object
        test_url = ENV['IMAGE_ROOT'] + matching_object.key
        return "http://migildi.com/500level/png2jpg.php?i=#{URI.escape(test_url)}"
      end
    end

    nil
  end

  def search_sub_dirs
    @search_sub_dirs ||= if gender == "Mens"
      ["","MEN","Men","Unisex","KIDS","Kids"]
    else
      ["women","WOMEN","Women","","Unisex","MEN","Men"]
    end
  end

  def default_folder
    "#{league}/#{team}/#{@title}/"
  end

  def folder_with_artist
    "#{league}/#{team}/#{@title} (#{@artist})/"
  end

  def url_design
    return @url_design if @url_design

    if Validator.valid_folder?(default_folder)
      @url_design = "#{ENV['IMAGE_ROOT']}#{league}/#{team}/#{@title}"
    elsif Validator.valid_folder?(folder_with_artist)
      @url_design = "#{ENV['IMAGE_ROOT']}#{league}/#{team}/#{@title} (#{@artist})"
    end

    @url_design
  end

  def city
    @city ||= @design.team.city
  end

  def league
    @league ||= @design.team.league
  end

  def team
    @team ||= @design.team
  end

  def player
    @player ||= @design.team_player
  end

  def gender
    @gender ||= @handle[-2..-1] == "-1" ? "Womens" : "Mens"
  end

  def formatted_gender(gender)
    FORMATTED_GENDER[gender]
  end

  def missing_image_design_url?
    !url_design
  end

  def missing_design_url_error
    "MISSING \"/#{league}/#{team}/#{title}#{extension}/\" "
  end

  def missing_clothing_error(clothing)
    "MISSING \'/#{league}/#{team}/#{title}#{extension}/\ - #{clothing.base_name}'"
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
      sport = LEAGUE_SPORT[league]
      item_tags = [
        "player=#{player}",
        "gender=#{clothing.gender.downcase}",
        "style=#{clothing.style_tag}",
        "v=#{ENV['500_LEVEL_VERSION']}",
        "team=#{team.name}",
        "city=#{city}",
        "sport=#{sport}"
      ].join(',')

      [title, nil, artist, clothing.clothing_type, item_tags, published]
    else
      [nil,nil,nil,nil,nil,nil]
    end
  end
end
