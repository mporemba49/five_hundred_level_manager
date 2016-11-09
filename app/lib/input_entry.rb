require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist,:design

  def initialize(handle, title, artist)
    @handle = handle
    @title = title
    @artist = artist
    Rails.logger.info("ENTRY: #{handle}, #{title}, #{artist}")
    @design = TeamPlayerDesign.includes(team_player: [:team])
                              .where(artist: @artist.downcase,
                                     name: @title.downcase).first
  end

  def url_string_for_clothing(clothing, image)
    search_sub_dirs.each do |sub_dir|
      test_url = clothing.image_url_builder(url_design, sub_dir, image)
      rootless_url = test_url.gsub(/.*\/#{league}/,league)
      puts rootless_url.downcase
      matching_object = Validator.objects.select { |object| object.key.downcase == rootless_url.downcase }.first

      if matching_object
        test_url = ENV['IMAGE_ROOT'] + matching_object.key
        return URI.escape(test_url)
      end
    end

    nil
  end

  def search_sub_dirs
    ["Men","Women","Kids","","MEN","Unisex","KIDS", "women","WOMEN"]
  end

  def default_folder
    "#{league}/#{team}/#{@title}/"
  end

  def folder_with_artist
    "#{league}/#{team}/#{@title} (#{@artist})/"
  end

  def url_design
    return @url_design if @url_design

    if Validator.valid_folder?(folder_with_artist)
      @url_design = "#{ENV['IMAGE_ROOT']}#{league}/#{team}/#{@title} (#{@artist})"
    elsif Validator.valid_folder?(default_folder)
      @url_design = "#{ENV['IMAGE_ROOT']}#{league}/#{team}/#{@title}"
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

  def missing_image_design_url?
    !url_design
  end

  def missing_design_url_error
    "MISSING \"/#{league}/#{team}/#{title}/\" "
  end

  def missing_clothing_error(clothing)
    "MISSING \'/#{league}/#{team}/#{title}/\ - #{clothing.base_name}'"
  end

  def missing_royalty_error
    "MISSING \'/#{league}/#{team}/#{title}/\ - League Royalty'"
  end

  def clothing
    Clothing.includes(clothing_colors: [:color]).includes(:tags, :sizes)
  end

  def league_sport(league)
    sports = { 'MLB' => 'Baseball', 'NFL' => 'Football',
               'NBA' => 'Basketball', 'NHL' => 'Hockey' }
    sports[league]
  end

  def tags(clothing, published, first_line)
    if first_line
      sport = league_sport(league) || league
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
