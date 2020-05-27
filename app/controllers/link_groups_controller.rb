class LinkGroupsController < ApplicationController
  before_action :find_link_group, only: [:edit, :update, :destroy]
  before_action :find_channel
  before_action :channel_member?
  before_action :ajax_find, only: [:index, :create, :update, :destroy]

  def index
    @link_group = LinkGroup.new
  end

  def new
  end

  def create
    @link_group = @channel.link_groups.build(link_group_params)

    @link_group.position = LinkGroup.all.length * -1
    # 讓新增的@link_group永遠排在最前面第一個

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

  # group移動AJAX
  def move_group
    @link_group_move = params[:group_ids].map { |obj_id| LinkGroup.find(obj_id) }
    @link_group_move.each.with_index { |link_group, index| link_group.update(position: index) }

    head :ok
  end


  private
  def link_group_params
    params.require(:link_group).permit(:name)
  end

  def find_link_group
    @link_group = LinkGroup.find(params[:id])
    @subobject = @link_group
  end

  def ajax_find
    @link_groups = @channel.link_groups.order(:position).includes(:saved_links)
    @saved_link = SavedLink.new
  end
end
