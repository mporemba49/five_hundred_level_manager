class SizesController < ApplicationController
  def index
    @sizes = Size.all
  end

  def edit
    @size = Size.find(params[:id])
  end

  def update
    @size = Size.find(params[:id])
    if @size.update_attributes(sizes_params)
      flash[:notice] = 'Size updated'
      redirect_to sizes_path
    else
      flash[:error] = 'Size was not updated'
      render :edit
    end
  end

  private

  def sizes_params
    params.require(:size).permit(:name, :sku)
  end
end
