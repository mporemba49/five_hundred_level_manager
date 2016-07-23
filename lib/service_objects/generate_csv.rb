class GenerateCsv
  HEADER = ["Handle","Title","Body (HTML)","Vendor","Type","Tags","Published","Option1 Name","Option1 Value","Option2 Name","Option2 Value","Option3 Name","Option3 Value","Variant SKU","Variant Grams","Variant Inventory Tracker","Variant Inventory Qty","Variant Inventory Policy","Variant Fulfillment Service","Variant Price","Variant Compare At Price","Variant Requires Shipping","Variant Taxable","Variant Barcode","Image Src","Image Alt Text","Gift Card","Google Shopping / MPN","Google Shopping / Age Group","Google Shopping / Gender","Google Shopping / Google Product Category","SEO Title","SEO Description","Google Shopping / AdWords Grouping","Google Shopping / AdWords Labels","Google Shopping / Condition","Google Shopping / Custom Product","Google Shopping / Custom Label 0","Google Shopping / Custom Label 1","Google Shopping / Custom Label 2","Google Shopping / Custom Label 3","Google Shopping / Custom Label 4","Variant Image","Variant Weight Unit","Collection"].freeze

  def self.call(title_team_player_path, input_path)
    title_team_players = []
    missing_files = []
    CSV.foreach(title_team_player_path,headers: true) do |row|
      title_team_players << TitleTeamPlayer.new(row)
    end
    host_validator = HostValidator.new
    CSV.foreach(infile, col_sep: ",", encoding: "ISO8859-1") do |row|
      entry = InputEntry.new(row, host_validator)

      unless entry.image_design_url_exists?
        missing_files << "MISSING \"/#{entry.league}/#{entry.team}/#{entry.title}#{entry.extension}/\" "
        next 
      end

      last_style = ''
      entry.products.each do |product|
        first_line = product.handle != last_style
        last_style = product.handle 
        shuffled_colors = Hash[product.valid_colors.to_a.shuffle]
        shuffled_colors.each_with_index do |color, index|
          product.csv_lines_for_color(color[0], color[1], first_line && index == 0)
        end
      end
    end

  end
end
