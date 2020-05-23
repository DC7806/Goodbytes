class SavedLinksController < ApplicationController
  before_action :find_saved_link, except: [:new, :create]
  before_action :find_channel
  before_action :channel_member?
  
  def new
    @saved_link = SavedLink.new(link_group_id: params[:link_group_id])
  end

  def create
    @saved_link = SavedLink.new(saved_link_params)

    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)

    if @saved_link.save
      # @link_group = LinkGroup.new
      @ajax_create_link = { ok: true }
    else
      @ajax_create_link = { ok: false, message: 'Create Error!' }
    end
  end

  def edit
  end

  def update
    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)

    if @saved_link.update(saved_link_params)
      @link_group = LinkGroup.new
      @ajax_update_link = { ok: true }
    else
      @ajax_update_link = { ok: false, message: 'Update Error!' }
    end
  end

  def destroy
    @link_groups = @channel.link_groups.order(created_at: :asc).includes(:saved_links)
    # @link_group = LinkGroup.new

    if @saved_link.destroy 
      @ajax_destroy_link = { ok: true }
    end
  end

  private
  def saved_link_params
    params.require(:saved_link).permit( :url, 
                                        :subject, 
                                        :summary,
                                        :link_group_id )
  end

  def find_saved_link
    @saved_link = SavedLink.find(params[:id])
    @subobject = @saved_link
  end
end
