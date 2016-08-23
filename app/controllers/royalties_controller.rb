class RoyaltiesController < ApplicationController
  def index
    @royalties = Royalty.order(:code)
  end

  def new
    @royalty = Royalty.new
  end

  def edit
    @royalty = Royalty.find(params[:id])
  end

  def update
    @royalty = Royalty.find(params[:id])

    if @royalty.update_attributes(royalty_params)
      flash[:notice] = "Royalty Updated"
      redirect_to royalties_path
    else
      flash[:error] = "Royalty Not Updated"
      render :edit
    end
  end

  def create
    @royalty = Royalty.new(royalty_params)

    if @royalty.save
      flash[:notice] = "Royalty Saved"
      redirect_to royalties_path
    else
      flash[:error] = "Royalty Not Saved"
      render :new
    end
  end

  private

  def royalty_params
    params.require(:royalty).permit(:code, :percentage, :league)
  end
end
