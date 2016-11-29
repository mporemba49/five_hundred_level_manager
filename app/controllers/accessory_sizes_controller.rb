class AccessorySizesController < ApplicationController
  def edit
    @accessory = Accessory.includes(:accessory_sizes).find(params[:accessory_id])
  end

  def update
    @accessory = Accessory.includes(:accessory_sizes).find(params[:accessory_id])
    price_updates = price_params.keep_if { |key, value| key.split(" ").first == "price" && value != "" }
    weight_updates = weight_params.keep_if { |key, value| key.split(" ").first == "weight" && value != "" }
    AccessorySize.where(accessory: @accessory).each do |accessory_size|
      price = price_updates["price #{accessory_size.id}"] || ""
      weight = weight_updates["weight #{accessory_size.id}"] || ""
      accessory_size.update_attribute(:price, price) unless price == ""
      accessory_size.update_attribute(:weight, weight) unless weight == ""
    end

    redirect_to accessory_path(@accessory)
  end

  private

  def price_params
    params.require(:size_1).first.permit!
  end

  def weight_params
    params.require(:size_2).first.permit!
  end

end