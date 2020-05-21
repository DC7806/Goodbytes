class LinkGroupsController < ApplicationController
  before_action :find_link_group, only: [:edit, :update, :destroy]
  before_action :find_channel
  before_action :channel_member?
  
  def index
    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)
    @saved_link  = SavedLink.new
  end

  def new
    @link_group = LinkGroup.new
  end

  def create
    @link_group            = LinkGroup.new(link_group_params)
    @link_group.channel_id = params[:channel_id]

    if @link_group.save
      redirect_to link_group_index_path(@link_group)
    else
      render :new
    end
  end

  def edit
  end

  def update

    if @link_group.update(link_group_params)
      redirect_to link_group_index_path(@link_group)
    else
      render :edit
    end
  end

  def destroy
    if @link_group.destroy 
      redirect_to link_group_index_path(@link_group)
    end
  end

  private
  def link_group_params
    params.require(:link_group).permit(:name)
  end

  def find_link_group
    @link_group = LinkGroup.find(params[:id])
    @subobject = @link_group
  end
end
