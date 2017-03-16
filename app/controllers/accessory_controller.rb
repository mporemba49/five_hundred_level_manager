class AccessoryController < ApplicationController
  before_action :require_login

  def index
    @accessory = Accessory.unscoped.includes(:sizes, :accessory_sizes).joins(:sizes)
                        .order(active: :desc, base_name: :asc)
                        .order("sizes.ordinal")
                        .all
    @sales_channels = SalesChannel.all
  end

  def new
    @accessory = Accessory.new
    @sizes = []
  end

  def show
    @accessory = Accessory.unscoped.includes(:colors, :tags, :sizes, :accessory_sizes).find(params[:id])
  end

  def edit
    @accessory = Accessory.unscoped.find(params[:id])
    @sizes = @accessory.sizes.pluck(:name)
  end

  def update
    @accessory = Accessory.unscoped.find(params[:id])
    @options = [params[:options_1], params[:options_2], params[:options_3]].join( )
    sizes = params[:accessory].delete(:sizes)
    @sizes = sizes.reject { |size| size == "0" }
    if @accessory.update_attributes(accessory_params)
      @accessory.add_sizes(@sizes)
      redirect_to accessory_path(@accessory)
    else
      flash[:error] = "Accessory could not be saved"
      render :edit
    end
  end

  def create
    sizes = params[:accessory].delete(:sizes)
    @sizes = sizes.reject { |size| size == "0" }
    @accessory = Accessory.new(accessory_params)

    if @accessory.save
      flash[:notice] = "New Accessory Saved"
      @accessory.add_sizes(@sizes)
      redirect_to accessory_path(@accessory)
    else
      flash[:error] = "Accessory Not Saved"
      render :new
    end
  end

  def toggle_active
    @accessory = Accessory.unscoped.find(params[:accessory_id])
    @accessory.update_attribute(:active, !@accessory.active)
    flash[:notice] = "Accessory is now #{@accessory.active ? 'active' : 'inactive' }"
    redirect_to accessory_path(@accessory)
  end

  def mass_toggle
    @accessories = Accessory.unscoped.find(params[:accessory_ids])
    @accessories.each { |c| c.update_attribute(:active, !c.active) }
    flash[:notice] = "Accessory activation change"
    redirect_to root_path
  end

  private

  def accessory_params
    params.require(:accessory).permit(:base_name, :accessory_type, :style, :extension, :gender, :product_sku, :body,
                                      :handle_extension, :sku, :brand_id, :option_one, :option_two, :option_three, sizes: [])
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end
end
