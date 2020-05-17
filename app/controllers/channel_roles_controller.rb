class ChannelRolesController < ApplicationController
  before_action :find_channel
  before_action :channel_admin?, only: [:update, :destroy]

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
    params_require(:invite_token)
    invite = Invite.find_by(token: @invite_token)

    if invite && @channel.update_role(current_user.id, member)
      invite.destroy
      notice = "歡迎加入"
    else
      notice = "無效的操作"
    end
    redirect_to root_path, notice: notice
  end

  def update
    params_require(:user_id, :role)
    if @channel.update_role(@user_id, @role)
      notice = "權限更新成功"
    else
      notice = "權限更新失敗"
    end
    redirect_to root_path, notice: notice
  end

  def destroy
    params_require(:user_id)
    relationship = @channel.relationship(@user_id)
    if relationship.role == admin
      notice = "不能開除admin"
    else
      relationship.destroy
      notice = "成功刪除！"
    end
    redirect_to root_path, notice: notice
  end

end
