require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist,:design

  def initialize(design={})
    team = design['Team'].strip
    player = design['Player'].strip
    league = design['League'].strip
    @handle = design['Handle']
    @title = design['Title'].strip
    @artist = design['Artist'].strip
    Rails.logger.info("ENTRY: #{league}, #{handle}, #{title}, #{artist}")
    @team = Team.find_by(name: team, league: league)
    @player = team.team_players.find_by_player(player) if @team
    @design = @player.designs.includes(team_player: [:team]).find_by(artist: @artist.downcase, name: @title.downcase) if @player
  end

  def url_string_for_item(item, image)
    search_sub_dirs.each do |sub_dir|
      test_url = item.image_url_builder(url_design, sub_dir, image)
      rootless_url = test_url.gsub(ENV['IMAGE_ROOT'],'')
      matching_object = Validator.objects.select { |object| object.key.downcase == rootless_url.downcase }.first

      if matching_object
        test_url = ENV['IMAGE_ROOT'] + matching_object.key
        return URI.escape(test_url)
      end
    end

    nil
  end

  def search_sub_dirs
    ["Men","Women","Kids","","MEN","Unisex","KIDS","women","WOMEN","Accessories"]
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

  def missing_design?
    !@design
  end

  def missing_design_error
    "MISSING #{title} - Team, league, or player mismatch"
  end
  
  def missing_design_url_error
    "MISSING \"/#{league}/#{team}/#{title}/\" "
  end

  def missing_item_error(item)
    "MISSING \'/#{league}/#{team}/#{title}/\ - #{item.base_name}'"
  end

  def missing_royalty_error
    "MISSING \'/#{league}/#{team}/#{title}/\ - League Royalty'"
  end

  def clothing
    Clothing.includes(clothing_colors: [:color]).includes(:tags, :sizes)
  end

  def accessory
    Accessory.includes(accessory_colors: [:color]).includes(:tags, :sizes)
  end

  def league_sport(league)
    sports = { 'MLB' => 'Baseball', 'NFL' => 'Football',
               'NBA' => 'Basketball', 'NHL' => 'Hockey' }
    sports[league]
  end

  def tags(item, published, first_line)
    if first_line
      sport = league_sport(league) || league
      if /\A\d+\z/.match(sport.split(' ').last)
        sport = sport.split(' ')
        sport.pop
        sport = sport.join(' ')
      end
      item_tags = [
        "player=#{player}",
        "gender=#{item.gender.downcase}",
        "style=#{item.style_tag}",
        "v=#{ENV['500_LEVEL_VERSION']}",
        "team=#{team.name}",
        "city=#{city}",
        "sport=#{sport}"
      ].join(',')
      if item.respond_to?(:clothing_type)
        item_type = item.clothing_type
      else
        item_type = item.accessory_type
      end

      [title, nil, artist, item_type, item_tags, published]
    else
      [nil,nil,nil,nil,nil,nil]
    end
  end
end
