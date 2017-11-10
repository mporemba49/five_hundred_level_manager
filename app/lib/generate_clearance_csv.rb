require 'csv'

class GenerateClearanceCsv

  def self.call(inventory_item_ids, sales_channel_id)
    header = ["Handle","Title","Body (HTML)","Vendor","Type","Tags","Published","Option1 Name","Option1 Value","Option2 Name","Option2 Value","Option3 Name","Option3 Value","Variant SKU","Variant Grams","Variant Inventory Tracker","Variant Inventory Qty","Variant Inventory Policy","Variant Fulfillment Service","Variant Price","Variant Compare At Price","Variant Requires Shipping","Variant Taxable","Variant Barcode","Image Src","Image Alt Text","Gift Card","Google Shopping / MPN","Google Shopping / Age Group","Google Shopping / Gender","Google Shopping / Google Product Category","SEO Title","SEO Description","Google Shopping / AdWords Grouping","Google Shopping / AdWords Labels","Google Shopping / Condition","Google Shopping / Custom Product","Google Shopping / Custom Label 0","Google Shopping / Custom Label 1","Google Shopping / Custom Label 2","Google Shopping / Custom Label 3","Google Shopping / Custom Label 4","Variant Image","Variant Weight Unit"]
    output_csv_lines = [header]
    missing_files = []
    sales_channel = SalesChannel.find_by_id(sales_channel_id)
    InventoryItem.where(id: inventory_item_ids).includes(:team_player_design, :team_player, :size, :color, :producible).find_in_batches do |batch|
      leagues_and_teams = InventoryItem.build_leagues_and_teams(batch)
      Validator.league_and_teams = leagues_and_teams
      batch.each do |item|
        unless entry = item.build_entry
          missing_files << InputEntry.missing_item_data(item)
          next
        end
        unless entry.complete
          missing_files << InputEntry.failed_completeness(item)
          next
        end
        product = item.producible
        product.entry = entry
        royalty = Royalty.find_by_league(entry.league)
        if !royalty
          missing_files << entry.missing_royalty_error
          next
        end
        line_success = false
        product.royalty_sku = royalty.code + sales_channel.sku
        if product.class.name == "Clothing"
          product_color = ClothingColor.where(clothing_id: product.id, color_id: item.color.id).first
        else
          product_color = AccessoryColor.where(accessory_id: product.id, color_id: item.color.id).first
        end
        if !product_color
          missing_files << entry.missing_product_color
          next
        end
        test_line = product.csv_lines_for_clearance(item, product_color)
        if test_line
          test_line = item.add_quantity(test_line)
          line_success = true
          output_csv_lines += test_line
        end
        missing_files << entry.missing_item_error(product) unless line_success
      end
      Validator.reset
    end
    [output_csv_lines, missing_files]
  end

end