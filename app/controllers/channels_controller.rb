class ChannelsController < ApplicationController
  before_action :find_channel, except: [:create]
  def show
  end

  def create
    if Channel.create(channel_params)
      redirect_to root_path, notice: "channel新增成功"
    else
      redirect_to root_path, notice: "channel新增失敗"
    end
  end
  def update
    @channel.update(channel_params)
    redirect_to root_path, notice: "channel更新成功"
  end
  def destroy
    @channel.destroy
    redirect_to root_path, notice: "channel刪除成功"
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
  
end
