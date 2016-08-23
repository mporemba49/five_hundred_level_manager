class SalesChannelsController < ApplicationController
  def index
    @sales_channels = SalesChannel.order(:name)
  end

  def new
    @sales_channel = SalesChannel.new
  end

  def edit
    @sales_channel = SalesChannel.find(params[:id])
  end

  def update
    @sales_channel = SalesChannel.find(params[:id])

    if @sales_channel.update_attributes(royalty_params)
      flash[:notice] = "SalesChannel Updated"
      redirect_to sales_channels_path
    else
      flash[:error] = "SalesChannel Not Updated"
      render :edit
    end
  end

  def create
    @sales_channel = SalesChannel.new(royalty_params)

    if @sales_channel.save
      flash[:notice] = "Sales Channel Saved"
      redirect_to sales_channels_path
    else
      flash[:error] = "Sales Channel Not Saved"
      render :new
    end
  end

  private

  def sales_channel_params
    params.require(:sales_channel).permit(:name, :percentage, :sku)
  end
end
