require 'csv'

class GenerateCsv
  HEADER = ["Handle","Title","Body (HTML)","Vendor","Type","Tags","Published","Option1 Name","Option1 Value","Option2 Name","Option2 Value","Option3 Name","Option3 Value","Variant SKU","Variant Grams","Variant Inventory Tracker","Variant Inventory Qty","Variant Inventory Policy","Variant Fulfillment Service","Variant Price","Variant Compare At Price","Variant Requires Shipping","Variant Taxable","Variant Barcode","Image Src","Image Alt Text","Gift Card","Google Shopping / MPN","Google Shopping / Age Group","Google Shopping / Gender","Google Shopping / Google Product Category","SEO Title","SEO Description","Google Shopping / AdWords Grouping","Google Shopping / AdWords Labels","Google Shopping / Condition","Google Shopping / Custom Product","Google Shopping / Custom Label 0","Google Shopping / Custom Label 1","Google Shopping / Custom Label 2","Google Shopping / Custom Label 3","Google Shopping / Custom Label 4","Variant Image","Variant Weight Unit","Collection"]

  def self.call(title_team_player_path, sales_channel_id)
    output_csv_lines = [HEADER]
    missing_files = []
    sales_channel = SalesChannel.find_by_id(sales_channel_id)

    CreateDesigns.call(title_team_player_path)

    CSV.foreach(title_team_player_path, encoding: "ISO8859-1", headers: true) do |row|
      handle = row['Handle']
      next if handle.blank?
      title = row['Title'].strip
      artist = row['Artist'].strip
      entry = InputEntry.new(handle, title, artist)
      royalty = Royalty.find_by_league(entry.league)

      if entry.missing_image_design_url?
        missing_files << entry.missing_design_url_error
        next
      end

      if !royalty
        missing_files << entry.missing_royalty_error
        next
      end

      last_style = ''
      line_success = false

      entry.clothing.each do |clothing_item|
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
        missing_files << entry.missing_clothing_error(clothing_item) unless line_success
        line_success = false
      end
    end

    [output_csv_lines, missing_files]
  end
end
