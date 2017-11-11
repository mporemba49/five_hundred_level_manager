class Clothing < ApplicationRecord
  before_save :set_handle_extension
  attr_accessor :entry, :royalty_sku

  has_many :clothing_colors, dependent: :destroy
  has_many :clothing_tags, dependent: :destroy
  has_many :clothing_sizes, dependent: :destroy
  has_many :tags, through: :clothing_tags
  has_many :colors, through: :clothing_colors
  has_many :sizes, through: :clothing_sizes
  has_many :inventory_items, as: :producible

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  default_scope { where(active: true) }

  validates_uniqueness_of :sku, blank: true
  validates_presence_of :base_name, :clothing_type, :style,
                        :gender, :price, :weight, :sku
            
  PUBLISHED = "TRUE"
  VARIANT_INVENTORY_QTY = "1"
  VARIANT_INVENTORY_POLICY = "deny"
  FULFILLMENT_SVC = "manual"
  VARIANT_REQUIRES_SHIPPING = "TRUE"
  VARIANT_TAXABLE = "FALSE"
  GIFT_CARD = "FALSE"
  CLOTHING_SKU = "C"

  def clothing_sku
    CLOTHING_SKU
  end

  def brand
    nil
  end

  def add_sizes(sizes)
    clothing_sizes.where.not(size_id: Size.where(name: sizes)).destroy_all
    sizes.each do |size|
      size_record = Size.find_by_name(size)
      ClothingSize.where(clothing: self, size: size_record).first_or_create if size_record
    end
  end

  def add_tags(tags)
    tags.each do |tag|
      tag_record = Tag.where(name: tag).first_or_create
      ClothingTag.where(clothing: self, tag: tag_record).first_or_create
    end
  end

  def image_url_builder(url_design, sub_dir, image)
    ext = extension != "" ? extension.capitalize : nil
    [url_design, ext, sub_dir, image].compact.join("/")
  end

  def handle
    return_handle = @entry.handle + handle_extension.downcase + "-" + style.parameterize
    return_handle.gsub!("men-s","mens")
    return_handle.gsub("--","-")
  end

  def entry_tags(first_line)
    @entry.tags(self, PUBLISHED, first_line)
  end

  def style_tag
    if (style.split(' ') & %w(Men's Women's Kids)).empty?
      case gender
      when 'Men'
        return "Men's #{style}"
      when 'Women'
        return "Women's #{style}"
      when 'Kids'
        return "Kids #{style}"
      end
    else
      return style
    end
  end

  def options_data(color, size)
    ["Style", style_tag, "Color", color.color_name, "Size", size]
  end

  def variants_data(clothing_size)
    [clothing_size.weight, nil, VARIANT_INVENTORY_QTY, VARIANT_INVENTORY_POLICY,
     FULFILLMENT_SVC, price, nil, VARIANT_REQUIRES_SHIPPING,
     VARIANT_TAXABLE,nil]
  end

  def img_alt_text(color)
    if ENV['STORE_TITLE'] == "Nomadic Apparel"
      "#{@entry.player} #{style}"
    else
      "#{@entry.player} #{style} | 500 LEVEL"
    end
  end

  def image_data(image_url, color)
    [image_url, img_alt_text(color.color_name)]
  end

  def seo_title
    if ENV['STORE_TITLE'] == "Nomadic Apparel"
      "#{@entry.player.player} #{style} | #{@entry.city} & #{@entry.league_sport(@entry.team.league)} Themed Apparel"
    else
      "#{@entry.title} #{style} | #{ENV['STORE_TITLE']}"
    end
  end

  def seo_description
    if @entry.team.league == "MLB"
      license = "MLBPA"
      sport = "Baseball"
    elsif @entry.team.league == "NHL"
      license = "NHLPA"
      sport = "Hockey"
    elsif @entry.team.league == "NFL"
      license = "NFLPA"
      sport ="Football"
    elsif @entry.team.league == "Baseball Hall of Fame"
      license = "National Baseball Hall of Fame"
    elsif @entry.team.league == "Music"
      license = "Periscope Records"
    end

    if ENV['STORE_TITLE'] == "Nomadic Apparel"
      description = nomadic_seo_description
    elsif license
      description = "Shop the #{@entry.design.name.titleize} #{style} at 500level.com & Buy Officially Licensed #{license} #{@entry.player.player} Gear at the Ultimate #{@entry.city} #{sport} Store!"
    else
      description = "Shop the #{@entry.design.name.titleize} #{style} at 500level.com. Officially Licensed by #{@entry.player.player}, 500 LEVEL is the Ultimate #{@entry.player.player} Store!"
    end
  end

  def nomadic_seo_description
    "Shop our #{@entry.player.player} #{style}, and other #{@entry.league_sport(@entry.team.league)} & #{@entry.city} themed apparel. Our awesome designs are custom made & printed in Austin, TX."
  end

  def adwords_grouping
    "#{@entry.team.league} #{@entry.team.name} #{@entry.player.player} #{style}"
  end

  def csv_line_for_size_and_color(size, clothing_color, clothing_size, image_url, first_line)
    columns = [handle] 
    columns += entry_tags(first_line)
    columns += options_data(clothing_color, size.name)
    columns += full_sku(size.sku, clothing_color)
    columns += variants_data(clothing_size) + image_data(image_url, clothing_color)
    columns += first_line ? first_line_entries(image_url, clothing_size) : later_line_entries(image_url, clothing_size)

    columns
  end

  def first_line_entries(image_url, clothing_size)
    if gender == "Kids" && style == "Onesie"
      csv_line = [GIFT_CARD, nil, gender, "Unisex", "Apparel & Accessories > Clothing > Baby & Toddler Clothing > Baby One-Pieces"]
    elsif gender == "Kids"
      csv_line = [GIFT_CARD, nil, gender, "Unisex", "Apparel & Accessories > Clothing > Shirts & Tops"]
    elsif gender == "Womens"
      csv_line = [GIFT_CARD, nil, "Adult", "Female", "Apparel & Accessories > Clothing > Shirts & Tops"]
    else
      csv_line = [GIFT_CARD, nil, "Adult", "Male", "Apparel & Accessories > Clothing > Shirts & Tops"]
    end
    csv_line << seo_title
    csv_line << seo_description
    csv_line << adwords_grouping
    8.times { csv_line << nil }
    csv_line << image_url
    csv_line << "oz"

    csv_line
  end

  def later_line_entries(image_url, clothing_size)
    csv_line = []
    16.times { csv_line << nil }
    csv_line << image_url
    csv_line << "oz"

    csv_line
  end

  def size_style_color_sku(size, clothing_color)
    [size, sku, clothing_color.color.sku].join('')
  end

  def full_sku(size, clothing_color)
    [
      [
        ENV['UPLOAD_VERSION'],
        CLOTHING_SKU + size_style_color_sku(size, clothing_color),
        "XX",
        @entry.team.id_string,
        @entry.player.sku,
        @entry.design.readable_sku,
        royalty_sku
      ].compact.join("-")
    ]
  end

  def csv_lines_for_color(clothing_color, first_line)
    lines = []
    image_url = @entry.url_string_for_item(self, clothing_color.image)
    return false unless image_url

    sizes.reload.each do |size|
      clothing_size = ClothingSize.where(clothing_id: self.id, size_id: size.id).first
      lines << csv_line_for_size_and_color(size, clothing_color, clothing_size, image_url, first_line)
      first_line = false if first_line
    end

    lines
  end

  def csv_lines_for_clearance(item, clothing_color)
    lines = []
    image_url = @entry.url_string_for_item(self, clothing_color.image)
    return false unless image_url
    logger.info "Image URL"
    clothing_size = ClothingSize.where(clothing_id: self.id, size_id: item.size.id).first
    return false unless clothing_size
    lines << csv_line_for_size_and_color(item.size, clothing_color, clothing_size, image_url, true)
    lines
  end

  private

  def set_handle_extension
    self.handle_extension = ""
    self.handle_extension = '-kids' if gender == 'Kids'
    self.handle_extension += "-#{extension.upcase}" if extension
  end
end
