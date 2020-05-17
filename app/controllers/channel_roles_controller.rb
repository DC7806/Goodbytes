class ChannelRolesController < ApplicationController
  before_action :find_channel
  before_action :channel_admin?, except: [:create]

  def new
    params_require(:email, :channel_id)
    if current_user.send_invitation
                   .by_channel(@channel_id)
                   .to(@email)
      message = "邀請信件已寄出"
    else
      message = "此成員已加入！"
    end
    redirect_to root_path, notice: message
  end

  def create
    params_require(:user_id, :id)
    if @channel.update_role(@user_id, 'member')
      redirect_to root_path, notice: "歡迎加入 channel #{@channel.name}"
      return
    end
    redirect_to root_path, notice: "無效的操作"
  end

  def update
    params_require(:user_id, :role, :id)
    @channel.update_role(@user_id, @role)
  end

  def destroy
    params_require(:user_id)
    relationship = @channel.relationship(@user_id)
    if relationship.role == 'admin'
      notice = "不能開除admin"
    else
      relationship.destroy
      notice = "成功刪除！"
    end
    redirect_to root_path, notice: notice
  end

  def find_channel
    params_require(:id)
    @channel = Channel.find(@id)
  end

  def channel_admin?
    unless @channel.role(current_user.id)=='admin'
      redirect_to root_path, notice: '沒有權限的操作'
    end
  end

end
