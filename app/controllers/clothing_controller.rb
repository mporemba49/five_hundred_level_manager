class ClothingController < ApplicationController
  def index
    @clothing = Clothing.unscoped.order(active: :desc).all
  end

  def new
    @clothing = Clothing.new
  end

  def show
    @clothing = Clothing.unscoped.includes(:colors, :tags).find(params[:id])
  end

  def edit
    @clothing = Clothing.unscoped.find(params[:id])
  end

  def update
    @clothing = Clothing.unscoped.find(params[:id])
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

  def toggle_active
    @clothing = Clothing.unscoped.find(params[:clothing_id])
    @clothing.update_attribute(:active, !@clothing.active)
    flash[:notice] = "Clothing is now #{@clothing.active ? 'active' : 'inactive' }"
    redirect_to clothing_path(@clothing)
  end

  private

  def clothing_params
    params.require(:clothing).permit(:base_name, :clothing_type, :style,
                                     :gender, :price, :weight, :extension,
                                     :handle_extension, :kids, sizes: [],)
  end
end
