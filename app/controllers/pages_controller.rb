class PagesController < ApplicationController
  
  def index
    @clothing = Clothing.unscoped.includes(:sizes).joins(:sizes)
                        .order(active: :desc, gender: :asc, base_name: :asc)
                        .order("sizes.is_kids, sizes.ordinal")
                        .all
    @accessory = Accessory.unscoped.includes(:accessory_sizes, :sizes).joins(:sizes)
                        .order(active: :desc, base_name: :asc)
                        .order("sizes.ordinal")
                        .all
    @sales_channels = SalesChannel.all
  end

  def kill_jobs
    Sidekiq.redis {|r| r.flushall }
    flash[:notice] = "All jobs cleared"
    redirect_to pages_index_path
  end

  def sku_csv
    BuildSkuCsvJob.perform_later(User.find(session[:user_id]).email)
    flash[:notice] = "An email with CSV attached will be sent soon"
    redirect_to pages_index_path
  end

  def create_csv
    if !params[:title_team_player].blank?
      sales_channel_id = params[:sales_channel]
      if params[:only_designs]
        CreateDesigns.call(params[:title_team_player].path)
        flash[:notice] = "Design records have been created"
      else
        uploaded_ttp_path = Uploader.call(params[:title_team_player].path)
        SendCsvJob.perform_later(User.find(session[:user_id]).email,
                                 uploaded_ttp_path, sales_channel_id)
        flash[:notice] = "An email with CSV attached will be sent soon"
      end
    else
      flash[:error] = "Input File and TitleTeamPlayer File Required"
    end
    redirect_to pages_index_path
  end
end
