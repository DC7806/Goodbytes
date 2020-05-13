class ChannelsController < ApplicationController
  before_action :find_channel, except: [:create]
  after_action :back_to_root, except: [:find_channel, :channel_params]

  def show
  end

  def create
    if Channel.create(channel_params)
      @notice = "channel新增成功"
    else
      @notice = "channel新增失敗"
    end
  end
  def update
    if @channel.update(channel_params)
      @notice = "channel更新成功"
    else
      @notice = "channel更新失敗"
    end
  end
  def destroy
    if @channel.destroy
      @notice = "channel刪除成功"
    else
      @notice = "channel刪除失敗"
    end
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end
  def channel_params
    params.require(:channel).permit(
      :name,
      :description
    )
  end
  def back_to_root
    redirect_to root_path, notice: @notice
  end
  
end
