class ClothingController < ApplicationController
  before_action :require_login

  def index
    @clothing = Clothing.unscoped.includes(:sizes).joins(:sizes)
                        .order(active: :desc, gender: :asc, base_name: :asc)
                        .order("sizes.is_kids, sizes.ordinal")
                        .all
    @sales_channels = SalesChannel.all
  end

  def new
    @clothing = Clothing.new
    @sizes = []
  end

  def show
    @clothing = Clothing.unscoped.includes(:colors, :tags, :sizes).find(params[:id])
  end

  def edit
    @clothing = Clothing.unscoped.find(params[:id])
    @sizes = @clothing.sizes.pluck(:name)
  end

  def update
    @clothing = Clothing.unscoped.find(params[:id])
    sizes = params[:clothing].delete(:sizes)
    @sizes = sizes.reject { |size| size == "0" }
    if @clothing.update_attributes(clothing_params)
      @clothing.add_sizes(@sizes)
      redirect_to clothing_path(@clothing)
    else
      flash[:error] = "Clothing could not be saved"
      render :edit
    end
  end

  def create
    sizes = params[:clothing].delete(:sizes)
    @sizes = sizes.reject { |size| size == "0" }
    @clothing = Clothing.new(clothing_params)

    if @clothing.save
      flash[:notice] = "New Clothing Saved"
      @clothing.add_sizes(@sizes)
      redirect_to clothing_path(@clothing)
    else
      flash[:error] = "Clothing Not Saved"
      render :new
    end
  end

  def toggle_active
    @clothing = Clothing.unscoped.find(params[:clothing_id])
    @clothing.update_attribute(:active, !@clothing.active)
    flash[:notice] = "Clothing is now #{@clothing.active ? 'active' : 'inactive' }"
    redirect_to clothing_path(@clothing)
  end

  def mass_toggle
    @clothings = Clothing.unscoped.find(params[:clothing_ids])
    @clothings.each { |c| c.update_attribute(:active, !c.active) }
    flash[:notice] = "Clothing activation change"
    redirect_to root_path
  end

  private

  def clothing_params
    params.require(:clothing).permit(:base_name, :clothing_type, :style,
                                     :gender, :price, :weight, :extension,
                                     :handle_extension, :sku, :kids, sizes: [])
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end
end
