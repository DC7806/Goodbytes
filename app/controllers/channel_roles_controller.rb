class ChannelRolesController < ApplicationController
  before_action :find_channel
  before_action :channel_admin?, except: [:create]

  def new
    params_require(:email, :id)
    invite_token  = generate_token(10)
    invites       = @channel.invites

    unless @channel.users.find_by(email: @email)
      last_invite = invites.find_by(reciever: @email)

      if last_invite
        invite_token = last_invite.token
      else
        invites.create(
          token: invite_token,
          sender_id: current_user.id,
          reciever: @email
        )
      end

      message = "channel邀請已送出"
    else
      message = "此成員已加入！"
    end
    redirect_to root_path, notice: message

  end

  def create
    params_require(:user_id, :id)
    if @channel.update_role(params[:user_id], 'member')
      redirect_to root_path, notice: "歡迎加入 channel #{@channel.name}"
      return
    end
    redirect_to root_path, notice: "無效的操作"
  end

  def update
    params_require(:user_id, :role, :id)
    @channel.update_role(
      params[:user_id],
      params[:role]
    )

  end

  def destroy
    params_require(:user_id, :id)
    @channel.relationship(@user_id).destroy
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
