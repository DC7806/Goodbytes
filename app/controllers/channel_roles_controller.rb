class ChannelRolesController < ApplicationController
  before_action :find_channel
  before_action :channel_admin?, except: [:create]

  def new
    email = params[:email]
    invite_token  = generate_token(10)
    invites       = @channel.invites

    unless @channel.users.find_by(email: email)
      last_invite = invites.find_by(reciever: email)

      if last_invite
        invite_token = last_invite.token
      else
        invites.create(
          token: invite_token,
          sender_id: current_user.id,
          reciever: email
        )
      end

      message = "channel邀請已送出"
    else
      message = "此成員已加入！"
    end
    redirect_to root_path, notice: message

  end

  def create
    org_role = OrganizationsUser.find_by(
      user_id: current_user.id,
      organization_id: @channel.organization_id
    )
    if org_role
      ChannelsOrgUser.create(
        organizations_user_id: org_role.id,
        channel_id: @channel.id,
        role: 'member'
      )
      redirect_to root_path, notice: "歡迎加入 channel #{@channel.name}"
      return
    end
    redirect_to root_path, notice: "無效的操作"
  end

  def update
    @channel.update_role(
      params[:user_id],
      params[:role]
    )

  end

  def destroy
    @channel.relationship(params[:user_id]).destroy
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
