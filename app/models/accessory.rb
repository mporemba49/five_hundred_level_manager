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
      when 'Accessories'
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

  def img_alt_text(color)
    gender_prefix = ''
    case gender
    when 'Men'
      gender_prefix = "Mens " unless style.include?('Mens')
    when 'Women'
      gender_prefix = "Womens " unless style.include?('Womens')
    when 'Kids'
      gender_prefix = "Kids " unless style.include?('Kids')
    end
    style + " " + color
  end

  def image_data(image_url, color)
    [image_url, img_alt_text(color.color_name)]
  end

  def seo_title
    "#{@entry.title} #{style} | 500 LEVEL"
  end

  def seo_description
    description = "Show off your fandom with 500 LEVEL's #{@entry.title} #{style}. Made by fans, "
    description << "for fans, 500 LEVEL sports apparel lets you rep your team in style. Browse our selection "
    description << "and order today."
    description
  end

  def csv_line_for_size_and_color(size, accessory_color, accessory_size, image_url, first_line)
    columns = [handle] 
    columns += entry_tags(first_line)
    columns += options_data(accessory_color, size.name)
    columns += full_sku(size.sku, accessory_color)
    columns += variants_data(accessory_size) + image_data(image_url, accessory_color)
    columns += first_line ? first_line_entries(image_url, accessory_size) : later_line_entries(image_url, accessory_size)
    columns += ([@entry.title] + " " + gender) if first_line

    columns
  end

  def first_line_entries(image_url, accessory_size)
    csv_line = [GIFT_CARD, nil, nil, nil, nil]
    csv_line << seo_title
    csv_line << seo_description
    9.times { csv_line << nil }
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