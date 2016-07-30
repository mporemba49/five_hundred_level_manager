class ColorsController < ApplicationController
  def index
    @colors = Color.all
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
