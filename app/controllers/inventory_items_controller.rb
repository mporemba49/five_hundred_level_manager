class InventoryItemsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @inventory_items = InventoryItem.all.order(sort_data + " " + sort_direction).includes(:team_player_design, :color, :size, team_player: [:team])
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
    if !params[:bulk_sku].blank?
      bulk_sku_path = Uploader.call(params[:bulk_sku].path)
      InventoryUploadJob.perform_later(bulk_sku_path)
      flash[:notice] = "Bulk inventory uploads are being processed"
    else
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
      @inventory_item.product = @item.style
      if @inventory_item.save
        flash[:notice] = "Inventory Item Saved"
      else
        @existing_item = InventoryItem.where(full_sku: @inventory_item.full_sku).first
        if @existing_item
          @existing_item.update_attributes(quantity: @existing_item.quantity + 1)
          flash[:notice] = "Item quantity increased"
        else
          flash[:error] = "Inventory Item Not Saved"
        end
      end
    end
    redirect_to inventory_items_path
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


  def mass_action
    if params['commit'] == 'Delete Items'
      @inventory_items = InventoryItem.where(id: params['inventory_item_ids'])
      @size = @inventory_items.size
      if @inventory_items.delete_all
        flash[:notice] = "#{@size} Items Deleted"
      else
        flash[:error] = 'Items Not Deleted'
      end
    else
      inventory_item_ids = params['inventory_item_ids']
      ClearanceCsvJob.perform_later(User.find(session[:user_id]).email,
                                 inventory_item_ids)
      flash[:notice] = "An email with CSV attached will be sent soon"
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
    params.require(:inventory_item).permit(:full_sku, :location, :quantity, :bulk_sku)
  end

  def sort_data
    if params[:sort] == "design"
      "team_player_designs.name"
    elsif params[:sort] == "player"
      "team_players.player"
    elsif params[:sort] == "size"
      "sizes.name"
    elsif params[:sort] == "color"
      "colors.name"
    elsif params[:sort] == "league"
      "teams.league"
    elsif params[:sort] == "team"
      "teams.name"
    elsif params[:sort] == "product"
      "product"
    elsif params[:sort] == "location"
      "location"
    elsif params[:sort] == "quantity"
      "quantity"
    elsif params[:sort] == "date_added"
      "created_at"
    elsif params[:sort] == "full_sku"
      "full_sku"
    else
      "team_player_id"
    end
  end

  def sort_column
    %w[design team player league product size color location quantity date_added full_sku].include?(params[:sort]) ? params[:sort] : "team_player_id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
