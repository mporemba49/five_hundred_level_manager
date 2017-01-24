class InventoryItemsController < ApplicationController
  def index
    @inventory_items = InventoryItem.all.includes(:team_player, :team_player_design, :color, :size)
    .paginate(page: params[:page])
  end

  def new
    @inventory_item = InventoryItem.new
  end

  def edit
    @inventory_item = InventoryItem.find(params[:id])
  end

  def update
    @inventory_item = InventoryItem.find(params[:id])
    if @inventory_item.update_attributes(item_params)
      flash[:notice] = 'Inventory Item updated'
      redirect_to inventory_items_path
    else
      flash[:error] = 'Inventory Item was not updated'
      render :edit
    end
  end

  def create()
    @inventory_item = InventoryItem.new
    full_sku = item_params[:full_sku]
    @inventory_item.full_sku = full_sku
    @inventory_item.team_player_design_id = TeamPlayerDesign.where(sku: full_sku.split('-')[6].to_i, team_player_id: full_sku.split('-')[5].to_i).first.id
    @inventory_item.team_player_id = TeamPlayer.where(id: full_sku.split('-')[5].to_i).first.id
    @inventory_item.color_id = Color.where(sku: full_sku.split('-')[2].slice(4..6)).first.id
    @inventory_item.size_id = Size.where(sku: full_sku.split('-')[2].slice(0)).first.id
    item = Accessory.unscoped.where(sku: full_sku.split('-')[2].slice(1..3)).first || Clothing.unscoped.where(sku: full_sku.split('-')[2].slice(1..3)).first
    inventory_item.producible_id = item.id
    inventory_item.producible_type = item.class.name
    if @inventory_item.save
      flash[:notice] = "Inventory Item Saved"
      redirect_to inventory_items_path
    else
      flash[:error] = "Clothing Not Saved"
      redirect_to inventory_items_path
    end
  end

  def check_sku
    if !params[:sku_csv].blank?
      uploaded_sku_path = Uploader.call(params[:sku_csv].path)
      CheckSkuJob.perform_later(User.find(session[:user_id]).email,
                                 uploaded_sku_path)
      flash[:notice] = "An email with CSV attached will be sent soon"
    else
      flash[:error] = "Input File File Required"
    end
    redirect_to inventory_items_path
  end

  def destroy
    @inventory_item = InventoryItem.find(params[:id])
    if @inventory_item.destroy!
      flash[:notice] = 'Item Deleted'
    else
      flash[:error] = 'Item Not Deleted'
    end

    redirect_to inventory_items_path
  end

  private

  def item_params
    params.require(:inventory_item).permit(:full_sku, :location, :quantity)
  end
end
