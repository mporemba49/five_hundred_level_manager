require 'uri'

class InputEntry
  attr_reader :handle, :title, :artist, :design, :unique, :player_add, :team_add, :sport_add, :city_add

  def initialize(design={})
    team = design['Team'].strip
    player = design['Player'].strip
    league = design['League'].strip
    @handle = design['Handle'] || design['Title'].strip.downcase.gsub(' ', '-')
    @title = design['Title'].strip
    @artist = design['Artist'].strip
    @unique = design['Unique'] || ENV['DEFAULT_SKU']
    Rails.logger.info("ENTRY: #{league}, #{handle}, #{title}, #{artist}")
    @team = Team.find_by(name: team, league: league)
    @player = @team.team_players.find_by_player(player) if @team
    @design = @player.designs.includes(team_player: [:team]).find_by(artist: @artist.downcase, name: @title.downcase) if @player
    @design.city = design['City'].strip if @design
    @player_add = design["Player1"].strip if design["Player1"]
    @team_add = design["Team1"].strip if design["Team1"]
    @sport_add = design["Sport1"].strip if design["Sport1"]
    @city_add = design["City1"].strip if design["City1"]
  end

  def url_string_for_item(item, image)
    test_url = item.image_url_builder(self.url_design, item.gender, image)
    test_url = URI.encode(test_url)
    return test_url if UrlChecker.url_exists?(test_url)
    nil
  end

  def default_folder
    "#{league}/#{team}/#{@title}/"
  end

  def folder_with_artist
    "#{league}/#{team}/#{@title} (#{@artist})/"
  end

  def url_design
    @url_design ||= "#{ENV['IMAGE_ROOT']}#{league}/#{team}/#{@title} (#{@artist})"
  end

  def city
    @city ||= @design.city
  end

  def league
    @league ||= @team.league
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

  def self.missing_item_data(inventory_item)
    "MISSING \'/Item Number #{inventory_item.id}/\ - Incomplete Data'"
  end


  def self.failed_completeness(inventory_item)
    "MISSING \'/Item Number #{inventory_item.id}/\ - Incomplete Data 2'"
  end

  def missing_product_color
    "MISSING \'/#{league}/#{team}/#{title}/\ - Color does not exist for product type'"
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
    sports[league] || league
  end

  def additional_tags(tag, data_add)
    data_array = data_add.split(";")
    size = 1
    tag_array = []
    data_array.each { |x| tag_array << tag + size.to_s; size += 1 }
    join_array = tag_array.zip(data_array)
    join_array.map { |x| x.join('=')}
  end

  def tags(item, published, first_line)
    if first_line
      sport = league_sport(league)
      if /\A\d+\z/.match(sport.split(' ').last)
        sport = sport.split(' ')
        sport.pop
        sport = sport.join(' ')
      end
      @player_add.present? ? player_add = additional_tags("player", @player_add) : player_add = []
      @team_add.present? ? team_add = additional_tags("team", @team_add) : team_add = []
      @sport_add.present? ? sport_add = additional_tags("sport", @sport_add) : sport_add = []
      @city_add.present? ? city_add = additional_tags("city", @city_add) : city_add = []
      league == "Baseball Hall of Fame" ? throwback_tag = ["sport=Throwbacks"] : throwback_tag = []
      item_tags_1 = ["player=#{player}", "gender=#{item.gender.downcase}"]
      item.brand.present? ? item_tags_2 = ["style=#{item.brand.name}"] : item_tags_2 = ["style=#{item.style}"]
      if item.custom_tag.present?
        custom_tags = ";" + item.custom_tag
      else
        custom_tags = ""
      end
      item_tags_3 = ["v=#{ENV['500_LEVEL_VERSION']}" + custom_tags, "team=#{team.name}", "city=#{city}", "sport=#{sport}"]
      item_tags_4 = ["title=#{item.entry.title}"]
      item.sku == unique ? item_tags_5 = ["listing=Unique"] : item_tags_5 = []
      item_tags_6 = player_add + team_add + sport_add + city_add + throwback_tag
      item_tags = (item_tags_1 + item_tags_2 + item_tags_3 + item_tags_4 + item_tags_5 + item_tags_6).join(',')
      if item.respond_to?(:clothing_type)
        item_type = item.clothing_type
      else
        if item.brand.present?
          item_type = item.gender.singularize
        else
          item_type = item.accessory_type
        end
      end

      [title, item.body, artist, item_type, item_tags, published]
    else
      [nil,nil,nil,nil,nil,nil]
    end
  end

  def complete
    return false unless @title
    return false unless @design
    return false unless @team
    return false unless @player
    true
  end

end
