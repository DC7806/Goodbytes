class ChannelsController < ApplicationController
  before_action :find_organization
  before_action :find_channel, except: [:new, :create]
  before_action :org_admin?, only: [:new, :create, :destroy]
  before_action :channel_admin?, only: [:edit, :update]

  def new
    new_params = params_require(:organization_id)
    @channel = Channel.new(**new_params)
  end

  def edit
    
  end
  
  def show
    params_require(:organization_id, :id)
  end

  def create
    params_require(:name, :organization_id, target: params[:channel])
    channel = Channel.new(channel_params)
    if channel.save
      @notice = "channel新增成功"
      channel.update_role(current_user.id, admin)
      # TODO: 創channel送group
    else
      @notice = "channel新增失敗"
    end
    redirect_to(root_path, notice: @notice) and return
  end

  def update
    params_require(:name, :organization_id, target: params[:channel])
    if @channel.update(channel_params)
      @notice = "channel更新成功"
    else
      @notice = "channel更新失敗"
    end
    redirect_to(root_path, notice: @notice) and return
  end

  def destroy
    params_require(:id, :organization_id, target: params[:channel])
    if @channel.destroy
      @notice = "channel刪除成功"
    else
      @notice = "channel刪除失敗"
    end
    redirect_to(root_path, notice: @notice) and return
  end

  private
  def channel_params
    params.require(:channel).permit(
      :name,
      :description,
      :organization_id
    )
  end

  
  
end
