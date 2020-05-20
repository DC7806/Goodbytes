class SavedLinksController < ApplicationController
  before_action :find_channel
  before_action :channel_member?
  def new
    @saved_link = SavedLink.new
  end

  def create
    @saved_link               = SavedLink.new(saved_link_params)
    @saved_link.link_group_id = params[:link_group_id]

    if @saved_link.save
      redirect_to organization_channel_link_groups_path
    else
      render :new
    end
  end

  def edit
    @saved_link = SavedLink.find(params[:id])
  end

  def update
    @saved_link = SavedLink.find(params[:id])

    if @saved_link.update(saved_link_params)
      redirect_to organization_channel_link_groups_path
    else
      render :edit
    end
  end

  def destroy
    @saved_link = SavedLink.find(params[:id])
    if @saved_link.destroy 
      redirect_to organization_channel_link_groups_path(**path_params)
    end
  end

  private
  def saved_link_params
    params.require(:saved_link).permit(:url, :subject, :summary)
  end
end