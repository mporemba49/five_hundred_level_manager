class ClothingController < ApplicationController
  def index
    @clothing = Clothing.all
  end

  def new
    @clothing = Clothing.new
  end

  def show
    @clothing = Clothing.includes(:colors, :tags).find(params[:id])
  end

  def edit
    @clothing = Clothing.find(params[:id])
  end

  def update
    @clothing = Clothing.find(params[:id])
    if @clothing.update_attributes(clothing_params)
      redirect_to clothing_path(@clothing)
    else
      render :edit
    end
  end

  def create
    @clothing = Clothing.new(clothing_params)

    if @clothing.save
      redirect_to clothing_path(@clothing)
    else
      render :new
    end
  end

  private

  def clothing_params
    params.require(:clothing).permit(:base_name, :clothing_type, :style,
                                     :gender, :price, :weight, :extension,
                                     :handle_extension, :kids, sizes: [],)
  end
end
