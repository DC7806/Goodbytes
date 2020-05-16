class LinkGroupsController < ApplicationController
  def index
    @link_groups = LinkGroup.order(created_at: :asc).includes(:saved_links)
  end

  def new
    @link_group = LinkGroup.new
  end

  def create
    @link_group = LinkGroup.new(link_group_params)
    @link_group.channel_id = params[:channel_id]

    if @link_group.save
      redirect_to channel_link_groups_path
    else
      render :new
    end
  end

  def edit
    @link_group = LinkGroup.find(params[:id])
  end

  def update
    @link_group = LinkGroup.find(params[:id])

    if @link_group.update(link_group_params)
      redirect_to channel_link_groups_path
    else
      render :edit
    end
  end

  def destroy
    @link_group = LinkGroup.find(params[:id])
    if @link_group.destroy 
      redirect_to channel_link_groups_path
    end
  end

  private
  def link_group_params
    params.require(:link_group).permit(:name)
  end
end
