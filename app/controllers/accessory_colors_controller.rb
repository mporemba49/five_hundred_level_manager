class AccessoryColorsController < ApplicationController
  def edit
    @accessory = Accessory.includes(:accessory_colors).find(params[:accessory_id])
    @selections = Color.all.map{ |color| { id: color.id, name: color.name } }
    @accessory.accessory_colors.each do |accessory_color|
      @selections.find{ |s| s[:id] == accessory_color.color_id }[:image] = accessory_color.image
    end
  end

  def update
    @accessory = Accessory.includes(:accessory_colors).find(params[:accessory_id])
    updated_colors = color_params.keep_if { |key, value| value != "" }
    AccessoryColor.where(accessory: @accessory).where.not(color_id: updated_colors.keys).destroy_all
    updated_colors.each do |color_id, image|
      accessory_color = AccessoryColor.where(accessory: @accessory, color_id: color_id).first_or_initialize
      accessory_color.update_attribute(:image, image) unless image == accessory_color.image
    end
    redirect_to accessory_path(@accessory)
  end

  private

  def color_params
    params.require(:colors).first.permit!
  end
end