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

    accessories = Accessory.includes(accessory_colors: [:color]).includes(:tags, :sizes)

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

      output = [output_csv_lines, missing_files]

      output = GenerateCsv.create_lines(output, clothing_items, :clothing_colors, entry)
      output = GenerateCsv.create_lines(output, accessories, :accessory_colors, entry)

    end

    output
  end

  def self.create_lines(output, items, color_method, entry)
    last_style = ''
    line_success = false
    output_csv_lines = output[0]
    missing_files = output[1]
    items.each do |item|
      item.entry = entry
      item.royalty_sku = royalty.code + sales_channel.sku
      first_line = item.handle != last_style || !line_success
      last_style = item.handle
      shuffled_colors = item.send(color_method).shuffle
      shuffled_colors.each do |color|
        test_line = accessory_item.csv_lines_for_color(color, !line_success)
        if test_line
          line_success = true
          output_csv_lines += test_line
        end
      end
      missing_files << entry.missing_item_error(item) unless line_success
      line_success = false
    end
    [output_csv_lines, missing_files]
  end
end
