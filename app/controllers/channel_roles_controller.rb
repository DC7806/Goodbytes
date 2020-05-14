class ChannelRolesController < ApplicationController
  before_action :find_channel
  before_action :channel_admin?

  def create

  end

  def update

  end

  def destroy

  end

  def find_channel
    @channel = Channel.find(params[:id])
  end

  def channel_admin?
    unless @channel.role(current_user.id)=='admin'
      redirect_to root_path, notice: '沒有權限的操作'
    end
  end

end
