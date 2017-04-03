class InventoryItemsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @inventory_items = InventoryItem.all.order(sort_column + " " + sort_direction).includes(:team_player, :team_player_design, :color, :size)
  end

  def new
    @inventory_item = InventoryItem.new
    @locations = Location.all
  end

  def edit
    @inventory_item = InventoryItem.find(params[:id])
    @locations = Location.all
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

  def create
    @inventory_item = InventoryItem.new
    full_sku = item_params[:full_sku]
    @inventory_item.full_sku = full_sku
    @inventory_item.location = item_params[:location]
    @team = Team.where(id: full_sku.slice(15..18)).first
    @player = @team.team_players.where(sku: full_sku.slice(20..22)).first
    @design = TeamPlayerDesign.where(sku: full_sku.slice(24..25).to_i, team_player_id: @player.id).first
    @inventory_item.team_player_id = @player.id
    @inventory_item.team_player_design_id = @design.id
    @inventory_item.color_id = Color.where(sku: full_sku.slice(8..10)).first.id
    @inventory_item.size_id = Size.where(sku: full_sku.slice(3..4)).first.id
    @item = Accessory.unscoped.where(sku: full_sku.slice(5..7)).first || Clothing.unscoped.where(sku: full_sku.slice(5..7)).first
    @inventory_item.producible_id = @item.id
    @inventory_item.producible_type = @item.class.name
    @inventory_item.player = TeamPlayer.find(@inventory_item.team_player_id).player
    @inventory_item.team = @team.name
    @inventory_item.league = @team.league
    @inventory_item.design = TeamPlayerDesign.find(@inventory_item.team_player_design_id).name
    @inventory_item.product = @item.style
    @inventory_item.artist = TeamPlayerDesign.find(@inventory_item.team_player_design_id).artist
    if @inventory_item.save
      flash[:notice] = "Inventory Item Saved"
      redirect_to inventory_items_path
    else
      @existing_item = InventoryItem.where(full_sku: @inventory_item.full_sku).first
      if @existing_item
        @existing_item.update_attributes(quantity: @existing_item.quantity + 1)
        flash[:notice] = "Item quantity increased"
      else
        flash[:error] = "Inventory Item Not Saved"
      end
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

  def destroy_all
    @inventory_items = InventoryItem.only_deleted
    @size = @inventory_items.size
    if @inventory_items.delete_all!
      flash[:notice] = "#{@size} Items Deleted"
    else
      flash[:error] = 'Items Not Deleted'
    end
    redirect_to inventory_items_path
  end


  def mass_delete
    @inventory_items = InventoryItem.where(id: params['inventory_item_ids'])
    @size = @inventory_items.size
    if @inventory_items.delete_all
      flash[:notice] = "#{@size} Items Deleted"
    else
      flash[:error] = 'Items Not Deleted'
    end

    redirect_to inventory_items_path
  end

  def soft_deleted
    @inventory_items = InventoryItem.only_deleted
  end

  def recover
    @inventory_item = InventoryItem.only_deleted.find(params[:id])
    if @inventory_item.recover
      flash[:notice] = "Inventory Item Recovered"
      redirect_to inventory_items_path
    else
      flash[:error] = "Inventory Item Not Recovered"
      redirect_to inventory_items_path
    end
  end



  private

  def item_params
    params.require(:inventory_item).permit(:full_sku, :location, :quantity)
  end

  def sort_column
    InventoryItem.column_names.include?(params[:sort]) ? params[:sort] : "team_player_id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
