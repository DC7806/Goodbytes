class SavedLinksController < ApplicationController
  before_action :find_saved_link, except: [:new, :create, :link_move_in_group, :link_change_group, :crawler]
  before_action :find_channel
  before_action :channel_member?
  before_action :find_link_groups, only: [:create, :update, :destroy]
  
  def new
  end

  def crawler
    crawler = Crawler.new(params[:saved_link][:url])

    if crawler.validate_url
      @crawler = crawler
      @saved_link = SavedLink.new(saved_link_params)
      @crawler_link = { ok: true }
    else
      @crawler_link = { ok: false }

    end
  end

  def create
    @saved_link = SavedLink.new(saved_link_params)

    @saved_link.position = (SavedLink.minimum(:position) || 0) - 1
    # 讓新增的@saved_link永遠排在最上面第一個

    if @saved_link.save
      @ajax_create_link = { ok: true }
    else
      @ajax_create_link = { ok: false, message: '創建失敗!' }
    end
  end

  def edit
  end

  def update
    if @saved_link.update(saved_link_params)
      @link_group = LinkGroup.new
      @ajax_update_link = { ok: true }
    else
      @ajax_update_link = { ok: false, message: '更新失敗!' }
    end
  end

  def destroy
    if @saved_link.destroy 
      @ajax_destroy_link = { ok: true }
    end
  end

  # link在group內移動 AJAX
  def link_move_in_group
    @saved_links = params[:saved_link_ids].map { |obj_id| SavedLink.find(obj_id) }
    @saved_links.each.with_index { |saved_link, index| saved_link.update(position: index) }

    head :ok
  end

  # link換group AJAX
  def link_change_group
    @from_saved_links = params[:from_link_ids].map { |obj_id| SavedLink.find(obj_id) }
    @from_saved_links.each.with_index { |saved_link, index| saved_link.update(position: index) }

    @to_group_id = params[:to_group_id].first
    @to_saved_links = params[:to_link_ids].map { |obj_id| SavedLink.find(obj_id) }
    @to_saved_links.each.with_index { |saved_link, index| saved_link.update(link_group_id: @to_group_id, position: index) }
    
    head :ok
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

  def find_link_groups
    @link_groups = @channel.link_groups.order(:position).includes(:saved_links)
  end
end
