class ClothingController < ApplicationController
  def new
    @clothing = Clothing.new
  end

  def create
    binding.pry
    @clothing = Clothing.new(clothing_params)

    if @clothing.save
      redirect_to clothing_path(@clothing)
    else
      render :new
    end
  end

  private

  def clothing_params
    params.require(:clothing).permit(:base_name, :clothing_type, :style, :gender, :price, :sizes, :weight, :extension, :handle_extension)
  end
end
