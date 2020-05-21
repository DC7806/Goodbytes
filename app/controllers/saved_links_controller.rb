class SavedLinksController < ApplicationController
  before_action :find_channel

  def new
    @saved_link = SavedLink.new
  end

  def create
    @saved_link = SavedLink.new(saved_link_params)
    @saved_link.link_group_id = params[:link_group_id]

    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)

    if @saved_link.save
      @link_group = LinkGroup.new
      @ajax_create_link = { ok: true }
    else
      @ajax_create_link = { ok: false, message: 'Create Error!' }
    end
  end

  def edit
    @saved_link = SavedLink.find(params[:id])
  end

  def update
    @saved_link = SavedLink.find(params[:id])

    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)

    if @saved_link.update(saved_link_params)
      @link_group = LinkGroup.new
      @ajax_update_link = { ok: true }
    else
      @ajax_update_link = { ok: false, message: 'Update Error!' }
    end
  end

  def destroy
    @saved_link = SavedLink.find(params[:id])

    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)
    @link_group = LinkGroup.new

    if @saved_link.destroy 
      @ajax_destroy_link = { ok: true }
    end
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end
  def saved_link_params
    params.require(:saved_link).permit(:url, :subject, :summary)
  end
end
