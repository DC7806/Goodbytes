class LinkGroupsController < ApplicationController
  before_action :find_link_group, only: [:edit, :update, :destroy]
  before_action :find_channel
  before_action :channel_member?
  before_action :for_ajax_render_find, only: [:create, :update, :destroy]
  
  def index
    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)
    @link_group = LinkGroup.new
    @saved_link = SavedLink.new
  end

  def new
    @link_group = LinkGroup.new
  end

  def create
    @link_group            = LinkGroup.new(link_group_params)
    @link_group.channel_id = params[:channel_id]

    if @link_group.save
      @ajax_create_group = { ok: true }
    else
      @ajax_create_group = { ok: false, message: 'Create Error!' }
    end
  end

  def edit
  end

  def update
    if @link_group.update(link_group_params)
      @link_group = LinkGroup.new
      @ajax_update_group = { ok: true }
    else
      @ajax_update_group = { ok: false, message: 'Update Error!' }
    end
  end

  def destroy
    if @link_group.destroy 
      @ajax_destroy_group = { ok: true }
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

  def for_ajax_render_find
    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)
    @saved_link = SavedLink.new
  end
end
