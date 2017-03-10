require 'csv'

class GenerateCsv
  HEADER = ["Handle","Title","Body (HTML)","Vendor","Type","Tags","Published","Option1 Name","Option1 Value","Option2 Name","Option2 Value","Option3 Name","Option3 Value","Variant SKU","Variant Grams","Variant Inventory Tracker","Variant Inventory Qty","Variant Inventory Policy","Variant Fulfillment Service","Variant Price","Variant Compare At Price","Variant Requires Shipping","Variant Taxable","Variant Barcode","Image Src","Image Alt Text","Gift Card","Google Shopping / MPN","Google Shopping / Age Group","Google Shopping / Gender","Google Shopping / Google Product Category","SEO Title","SEO Description","Google Shopping / AdWords Grouping","Google Shopping / AdWords Labels","Google Shopping / Condition","Google Shopping / Custom Product","Google Shopping / Custom Label 0","Google Shopping / Custom Label 1","Google Shopping / Custom Label 2","Google Shopping / Custom Label 3","Google Shopping / Custom Label 4","Variant Image","Variant Weight Unit","Collection"]

  def self.call(title_team_player_path, sales_channel_id)
    output_csv_lines = [HEADER]
    missing_files = []
    sales_channel = SalesChannel.find_by_id(sales_channel_id)
    league_and_teams = CreateDesigns.call(title_team_player_path)
    Validator.league_and_teams = league_and_teams
    clothing_items = Clothing.includes(clothing_colors: [:color]).includes(:tags, :sizes)
    acc = Accessory.includes(accessory_colors: [:color]).includes(:tags, :sizes, :brand).group_by { |a| a.brand.name if a.brand.present? }
    accessories = []
    accessories << acc[nil]
    accessories << acc['Apple']
    accessories << acc['Samsung']
    accessories.flatten!.compact! if accessories.present?

    CSV.foreach(title_team_player_path, encoding: "ISO8859-1", headers: true) do |row|
      next if row['Title'].blank?
      handle = row['Handle'] 
      handle = row['Title'].downcase.delete(' ') if handle.blank?
      entry = InputEntry.new(row)

      if entry.missing_design?
        missing_files << entry.missing_design_error
        next
      end

      if entry.missing_image_design_url?
        missing_files << entry.missing_design_url_error
        next
      end

      royalty = Royalty.find_by_league(entry.league)

      if !royalty
        missing_files << entry.missing_royalty_error
        next
      end

      last_style = ''
      line_success = false

      clothing_items.each do |clothing_item|
        clothing_item.entry = entry
        clothing_item.royalty_sku = royalty.code + sales_channel.sku

        first_line = clothing_item.handle != last_style || !line_success
        last_style = clothing_item.handle

        shuffled_colors = clothing_item.clothing_colors.shuffle
        shuffled_colors.each do |clothing_color|
          test_line = clothing_item.csv_lines_for_color(clothing_color, !line_success)
          if test_line
            line_success = true
            output_csv_lines += test_line
          end
        end
        missing_files << entry.missing_item_error(clothing_item) unless line_success
        line_success = false
      end
      accessories.each do |accessory_item|
        accessory_item.entry = entry
        accessory_item.royalty_sku = royalty.code + sales_channel.sku

        first_line = accessory_item.handle != last_style
        last_style = accessory_item.handle

        shuffled_colors = accessory_item.accessory_colors.shuffle
        shuffled_colors.each do |accessory_color|
          test_line = accessory_item.csv_lines_for_color(accessory_color, accessory_item.brand.present? ? first_line : !line_success)
          if test_line
            line_success = true
            output_csv_lines += test_line
          end
        end
        missing_files << entry.missing_item_error(accessory_item) unless line_success
        line_success = false
      end
    end

    [output_csv_lines, missing_files]
  end
end
