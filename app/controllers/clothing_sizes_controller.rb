class ClothingSizesController < ApplicationController
  def edit
    @clothing = Clothing.includes(:clothing_sizes).find(params[:clothing_id])
  end

  def update
    @clothing = Clothing.includes(:clothing_sizes).find(params[:clothing_id])
    updated_sizes = size_params.keep_if { |key, value| value != "" }
    ClothingSize.where(clothing: @clothing).each do |clothing_size|
      weight = updated_sizes["weight #{clothing_size.id}"] || ""
      clothing_size.update_attribute(:weight, weight) unless weight == ""
    end

    redirect_to clothing_path(@clothing)
  end

  private

  def size_params
    params.require(:sizes).first.permit!
  end

end