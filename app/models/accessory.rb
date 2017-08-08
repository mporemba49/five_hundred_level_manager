class Accessory < ApplicationRecord
  before_save :set_handle_extension
  attr_accessor :entry, :royalty_sku

  has_many :accessory_colors, dependent: :destroy
  has_many :accessory_tags, dependent: :destroy
  has_many :accessory_sizes, dependent: :destroy
  has_many :tags, through: :accessory_tags
  has_many :colors, through: :accessory_colors
  has_many :sizes, through: :accessory_sizes
  has_many :inventory_items, as: :producible
  belongs_to :brand

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  default_scope { where(active: true) }

  validates_uniqueness_of :sku, blank: true
  validates_presence_of :base_name, :accessory_type, :style,
                        :gender, :sku, :product_sku
            
  PUBLISHED = "TRUE"
  VARIANT_INVENTORY_QTY = "1"
  VARIANT_INVENTORY_POLICY = "deny"
  FULFILLMENT_SVC = "manual"
  VARIANT_REQUIRES_SHIPPING = "TRUE"
  VARIANT_TAXABLE = "FALSE"
  GIFT_CARD = "FALSE"
  PILLOW_SKU = "P"
  BLANKET_SKU = "B"

  def add_sizes(sizes)
    accessory_sizes.where.not(size_id: Size.where(name: sizes)).destroy_all
    sizes.each do |size|
      size_record = Size.find_by_name(size)
      AccessorySize.where(accessory: self, size: size_record).first_or_create if size_record
    end
  end

  def add_tags(tags)
    tags.each do |tag|
      tag_record = Tag.where(name: tag).first_or_create
      AccessoryTag.where(accessory: self, tag: tag_record).first_or_create
    end
  end

  def image_url_builder(url_design, sub_dir, image)
    ext = extension != "" ? extension.capitalize : nil
    [url_design, ext, sub_dir, image].compact.join("/")
  end

  def handle
    if brand.present?
      return_handle = @entry.handle + "-" + brand.name.parameterize + "-case"
      return_handle.gsub!("men-s","mens")
      return_handle.gsub("--","-")
    else
      return_handle = @entry.handle + handle_extension.downcase + "-" + style.parameterize
      return_handle.gsub!("men-s","mens")
      return_handle.gsub("--","-")
    end
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
      else
        return style
      end
    else
      return style
    end
  end

  def options_data(color, size)
    options_hash = { "Size" => size, "Style" => style_tag, "Color" => color.color_name }
    options_hash["Brand"]= brand.name if brand
    [option_one, options_hash[option_one], option_two, options_hash[option_two], option_three, options_hash[option_three]]
  end

  def variants_data(accessory_size)
    [accessory_size.weight, nil, VARIANT_INVENTORY_QTY, VARIANT_INVENTORY_POLICY,
     FULFILLMENT_SVC, accessory_size.price, nil, VARIANT_REQUIRES_SHIPPING,
     VARIANT_TAXABLE,nil]
  end

  def img_alt_text(color, size)
    if accessory_type == "Phone Cases"
      "#{@entry.player.player} #{brand.name} #{size.name} #{style} | 500 LEVEL"
    else
      "#{@entry.player.player} #{style} | 500 LEVEL"
    end
  end

  def image_data(image_url, color, size)
    [image_url, img_alt_text(color.color_name, size)]
  end

  def seo_title(accessory_size)
    if accessory_type == "Phone Cases"
      "#{@entry.design.name} #{brand.name} #{accessory_size.size.name} #{style} | 500 LEVEL"
    else
      "#{@entry.design.name} #{style} | 500 LEVEL"
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

    if license && accessory_type == "Phone Cases"
      description = "Shop the #{@entry.design.name.titleize} #{brand.name} #{size.name} #{style} at 500level.com & Buy Officially Licensed #{license} #{@entry.player.player} Phone Cases at the Ultimate #{@entry.team.city} #{sport} Store!"
    elsif license
      description = "Shop the #{@entry.design.name.titleize} #{style} at 500level.com & Buy Officially Licensed #{license} #{@entry.player.player} Gear at the Ultimate #{@entry.team.city} #{sport} Store!"
    elsif accessory_type == "Phone Cases"
      description = "Shop the #{@entry.design.name.titleize} #{brand.name} #{size.name} #{style} at 500level.com & Buy Officially Licensed #{@entry.player.player} Phone Cases at the Ultimate #{@entry.player.player} Store!"
    else
      description = "Shop the #{@entry.design.name.titleize} #{style} at 500level.com. Officially Licensed by #{@entry.player.player}, 500 LEVEL is the Ultimate #{@entry.player.player} Store!"
    end
  end

  def adwords_grouping
    "#{@entry.team.league} #{@entry.team.name} #{@entry.player.player} #{style}"
  end

  def csv_line_for_size_and_color(size, accessory_color, accessory_size, image_url, first_line)
    columns = [handle] 
    columns += entry_tags(first_line)
    columns += options_data(accessory_color, size.name)
    columns += full_sku(size.sku, accessory_color)
    columns += variants_data(accessory_size) + image_data(image_url, accessory_color, size)
    columns += first_line ? first_line_entries(image_url, accessory_size) : later_line_entries(image_url, accessory_size)
    columns += [@entry.title + " " + gender] if first_line

    columns
  end

  def first_line_entries(image_url, accessory_size)

    if accessory_type == "Pillow"
      category = "Home & Garden > Decor > Throw Pillows"
    elsif accessory_type == "Poster"
      category = "Home & Garden > Decor > Artwork > Posters, Prints, & Visual Artwork"
    elsif accessory_type == "Fleece Blanket"
      category = "Home & Garden > Linens & Bedding > Bedding > Blankets"
    elsif accessory_type == "Hats"
      category = "Apparel & Accessories > Clothing Accessories > Hats"
    elsif accessory_type == "Phone Cases"
      category = "Electronics > Communications > Telephony > Mobile Phone Accessories > Mobile Phone Cases"
    end

    csv_line = [GIFT_CARD, nil, "Adult", "Unisex", category]
    csv_line << seo_title(accessory_size)
    csv_line << seo_description
    csv_line << adwords_grouping
    8.times { csv_line << nil }
    csv_line << image_url
    csv_line << "oz"

    csv_line
  end

  def later_line_entries(image_url, accessory_size)
    csv_line = []
    16.times { csv_line << nil }
    csv_line << image_url
    csv_line << "oz"

    csv_line
  end

  def size_style_color_sku(size, accessory_color)
    [size, sku, accessory_color.color.sku].join('')
  end

  def full_sku(size, accessory_color)
    [
      [
        ENV['UPLOAD_VERSION'],
        product_sku + size_style_color_sku(size, accessory_color),
        brand ? brand.sku + "X" : "XX",
        @entry.team.id_string,
        @entry.player.sku,
        @entry.design.readable_sku,
        royalty_sku
      ].compact.join("-")
    ]
  end

  def csv_lines_for_color(accessory_color, first_line)
    lines = []
    image_url = @entry.url_string_for_item(self, accessory_color.image)
    return false unless image_url

    sizes.reload.each do |size|
      accessory_size = AccessorySize.where(accessory_id: self.id, size_id: size.id).first
      lines << csv_line_for_size_and_color(size, accessory_color, accessory_size, image_url, first_line)
      first_line = false if first_line 
    end

    lines
  end

  private

  def set_handle_extension
    self.handle_extension = ""
    self.handle_extension = '-kids' if gender == 'Kids'
    self.handle_extension += "-#{extension.upcase}" if extension
  end

end