class ClothingColorsController < ApplicationController
  def edit
    @clothing = Clothing.includes(:clothing_colors).find(params[:clothing_id])
    @selections = Color.all.map{ |color| { id: color.id, name: color.name } }
    @sales_channels = SalesChannel.all
    @clothing.clothing_colors.each do |clothing_color|
      @selections.find{ |s| s[:id] == clothing_color.color_id }[:image] = clothing_color.image
    end
  end

  def update
    @clothing = Clothing.includes(:clothing_colors).find(params[:clothing_id])
    updated_colors = color_params.keep_if { |key, value| value != "" }
    ClothingColor.where(clothing: @clothing).where.not(color_id: updated_colors.keys).destroy_all
    updated_colors.each do |color_id, image|
      clothing_color = ClothingColor.where(clothing: @clothing, color_id: color_id).first_or_initialize
      clothing_color.update_attribute(:image, image) unless image == clothing_color.image
    end
    redirect_to clothing_path(@clothing)
  end

  private

  def color_params
    params.require(:colors).first.permit!
  end
end
