class SavedLinksController < ApplicationController
  before_action :find_saved_link, except: [:new, :create]
  before_action :find_channel
  before_action :channel_member?
  def new
    @saved_link = SavedLink.new(link_group_id: params[:link_group_id])
  end

  def create
    @saved_link = SavedLink.new(saved_link_params)

    if @saved_link.save
      redirect_to link_group_index_path(@saved_link.link_group)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @saved_link.update(saved_link_params)
      redirect_to link_group_index_path(@saved_link.link_group)
    else
      render :edit
    end
  end

  def destroy
    if @saved_link.destroy 
      redirect_to link_group_index_path(@saved_link.link_group)
    end
  end

  private
  def saved_link_params
    params.require(:saved_link).permit(
      :url, 
      :subject, 
      :summary,
      :link_group_id
    )
  end

  def find_saved_link
    @saved_link = SavedLink.find(params[:id])
    @subobject = @saved_link
  end
end
