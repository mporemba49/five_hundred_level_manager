require 'csv'

class GenerateCsv
  HEADER = ["Handle","Title","Body (HTML)","Vendor","Type","Tags","Published","Option1 Name","Option1 Value","Option2 Name","Option2 Value","Option3 Name","Option3 Value","Variant SKU","Variant Grams","Variant Inventory Tracker","Variant Inventory Qty","Variant Inventory Policy","Variant Fulfillment Service","Variant Price","Variant Compare At Price","Variant Requires Shipping","Variant Taxable","Variant Barcode","Image Src","Image Alt Text","Gift Card","Google Shopping / MPN","Google Shopping / Age Group","Google Shopping / Gender","Google Shopping / Google Product Category","SEO Title","SEO Description","Google Shopping / AdWords Grouping","Google Shopping / AdWords Labels","Google Shopping / Condition","Google Shopping / Custom Product","Google Shopping / Custom Label 0","Google Shopping / Custom Label 1","Google Shopping / Custom Label 2","Google Shopping / Custom Label 3","Google Shopping / Custom Label 4","Variant Image","Variant Weight Unit","SKU"]

  def self.call(title_team_player, input)
    output_csv_lines = [HEADER]
    title_team_players = []
    missing_files = []

    CSV.foreach(title_team_player, headers: true) do |row|
      title_team_players << TitleTeamPlayer.new(row)
    end

    CSV.foreach(input, col_sep: ",", encoding: "ISO8859-1") do |row|
      entry = InputEntry.new(row, title_team_players)

      if entry.missing_image_design_url?
        missing_files << entry.missing_design_url_error
        next
      end

      last_style = ''
      entry.clothing.each do |clothing_item|
        clothing_item.entry = entry
        first_line = clothing_item.handle != last_style
        last_style = clothing_item.handle 
        shuffled_colors = clothing_item.clothing_colors.shuffle
        shuffled_colors.each_with_index do |clothing_color, index|
          test_line = clothing_item.csv_lines_for_color(clothing_color, first_line && index == 0)
          output_csv_lines += test_line if test_line
        end
      end
    end

    output_csv_lines
  end
end
