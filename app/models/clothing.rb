class Clothing < ApplicationRecord
  before_save :set_handle_extension

  SEASON = "winter"
  PUBLISHED = "TRUE"
  VIQ = "1"
  VIP = "deny"
  FS = "manual"
  RS = "TRUE"
  T = "FALSE"
  G = "FALSE"
  attr_accessor :kids
  attr_reader :tags, :colors
  has_and_belongs_to_many :tags

  def add_tags(tags)
    tags.each do |tag|
      tag_record = Tag.where(name: tag).first_or_create
      self.tags << tag_record
    end
  end

  def image_url_builder(url_design, sub_dir, image)
    [url_design, @extension, sub_dir, image].compact.join("/")
  end

  def handle
    @entry.handle + @handle_extension
  end

  def entry_tags(first_line)
    @entry.tags(self, PUBLISHED, first_line)
  end

  def options(color, size)
    "Style,#{@style},Color,#{color},Size,#{size},"
  end

  def variants
    ","+"#{@weight},"+","+VIQ+","+VIP+","+FS+","
  end

  def pricing
    "#{@price},,#{RS},#{T},,"
  end

  def img_src(image_url)
    image_url + ","
  end

  def img_alt_text(color)
    @style + " " + color + ","
  end

  def image_entries(image_url, color)
    img_src(image_url) + img_alt_text(color)
  end

  def first_line_entries(image_url)
    # -if first line write (SEO Title, SEO Description, Variant Image as URL, Collection)
    print G+","
    4.times { print "," }
    print "\"#{@entry.title}: #{gender}, #{@tags.join(",")} #{@entry.team} | 500Level.com\","
    print "\"#{@entry.title} #{@entry.team} #{gender} #{@type} from 500LEVEL. This #{@entry.player} #{@entry.team} #{@type.downcase} comes in multiple sizes and colors.\","
    9.times { print "," }
    print image_url
    2.times { print "," }
    print @entry.team
    print " (#{@entry.formatted_gender(gender)})"
  end

  def later_line_entries(image_url)
    16.times { print "," }
    print image_url
    2.times { print "," }
  end

  def csv_line_for_size_and_color(size, color, image_url, first_line)
    print handle
    print entry_tags(first_line)
    print options(color, size)
    print variants
    print pricing
    print image_entries(image_url, color)
    if first_line
      first_line_entries(image_url)
    else
      later_line_entries(image_url)
    end
  end

  def valid_colors
    @valid_colors ||= Hash[colors.map{ |color, image_url| !@entry.url_string_for_product(self, image_url).nil? ? [color, image_url] : nil }.compact]
  end

  def csv_lines_for_color(color, image, first_line)
    image_url = @entry.url_string_for_product(self, image)
    return false unless image_url

    @sizes.each do |size|
      csv_line_for_size_and_color(size, color, image_url, first_line)
      first_line = false if first_line
      puts ""
    end

    return true
  end

  private

  def set_handle_extension
    handle_extension = ","
    handle_extension = '-kids' if gender == 'Kids'
    handle_extension += "-#{extension}" if extension
  end
end
