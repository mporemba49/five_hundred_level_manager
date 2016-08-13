class ReservedDesignsController < ApplicationController
  def index
    @reserved_designs = ReservedDesign.all
  end

  def new
    @reserved_design = ReservedDesign.new
  end

  def edit
    @reserved_design = ReservedDesign.find(params[:id])
  end

  def create
    @reserved_design = ReservedDesign.new(design_params)

    if @reserved_design.save
      flash[:notice] = "Reserved Design Saved with SKU #{@reserved_design.design_sku}"
      redirect_to reserved_designs_path
    else
      flash[:error] = "Reserved Design Not Saved"
      render :new
    end
  end

  def update
    @reserved_design = ReservedDesign.find(params[:id])
    if @reserved_design.update_attributes(design_params)
      flash[:notice] = "Reserved Design Updated"
      redirect_to reserved_designs_path
    else
      flash[:error] = "Reserved Design Not Updated"
      render :edit
    end
  end

  private 

  def design_params
    params.require(:reserved_design).permit(:artist, :snippet, :design_sku)
  end
end
