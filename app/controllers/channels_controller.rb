class ChannelsController < ApplicationController
  before_action :find_channel,  except: [:new, :create]
  before_action :find_organization
  before_action :org_admin?,      only: [:new, :create, :destroy]
  before_action :channel_admin?,  only: [:edit, :update]
  before_action :channel_member?, only: [:show]

  def new
    @channel   = Channel.new(
      organization_id: current_organization_id
    )
  end

  def edit
    @organization_id = @channel.organization_id
    @users           = @channel.users_with_role
  end
  
  def show
    @articles = @channel.articles.order(created_at: :desc)
  end

  def create
    channel = Channel.new(channel_params)
    if channel.save
      @notice = "channel新增成功"
      channel.update_role(current_user.id, admin)
      channel.link_groups.create(name: "INBOX")
      session["goodbytes7788"]["channel_id"] = channel.id
      path = channel_path
    else
      @notice = "channel新增失敗"
      path = root_path
    end
    redirect_to(path, notice: @notice) and return
  end

  def update
    if @channel.update(channel_params)
      @notice = "channel更新成功"
    else
      @notice = "channel更新失敗"
    end
    redirect_to(root_path, notice: @notice) and return
  end

  def destroy
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
