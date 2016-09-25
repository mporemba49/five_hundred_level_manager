class SizesController < ApplicationController
  def index
    @sizes = Size.all
  end

  def edit
    @size = Size.find(params[:id])
  end

  def new
    @size = Size.new
  end

  def create
    @size = Size.new(sizes_params)
    if @size.save
      flash[:notice] = 'Size created'
      redirect_to size_path(@size)
    else
      flash[:error] = 'Size was not created'
      render :new
    end
  end

  def destroy
    @size = Size.find(params[:id])
    if @size.destroy!
      flash[:notice] = 'Size deleted'
    else
      flash[:error] = 'Size was not deleted'
    end

    redirect_to sizes_path
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
    params.require(:size).permit(:name, :sku, :is_kids, :ordinal)
  end
end
