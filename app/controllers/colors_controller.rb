class ColorsController < ApplicationController
  def index
    @colors = Color.order(:name)
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)

    if @color.save
      flash[:notice] = "Color saved"
      redirect_to colors_path
    else
      flash[:error] = "Color was not saved"
      render :new
    end
  end

  def edit
    @color = Color.find(params[:id])
  end

  def update
    @color = Color.find(params[:id])
    if @color.update_attributes(color_params)
      flash[:notice] = 'Color updated'
      redirect_to colors_path
    else
      flash[:error] = 'Color was not updated'
      render :edit
    end
  end

  private

  def color_params
    params.require(:color).permit(:name, :sku)
  end
end
