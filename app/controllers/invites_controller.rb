class InvitesController < ApplicationController

  before_action :params_injection
  skip_before_action :authenticate_user!, only: [:sign_up_and_join]
  # before_action :admin?
  def create
    # 必要參數: name organization_id email 
    
    invite_token  = generate_token(10)
    user          = User.find_by(email: @email)
    organization  = Organization.find(@organization_id)
    relationship  = organization.users
                                .find_by(email: @email)

    unless relationship 
      last_invite = organization.invites.find_by(reciever: @email)

      if last_invite
        invite_token = last_invite.token
      else
        organization.invites.create(
          token: invite_token,
          sender_id: current_user.id,
          reciever: @email
        )
      end

      InviteMailerJob.perform_later(
        Organization.find(@organization_id).name,
        @email, 
        invite_token, 
        !user
      )

      message = "邀請信件已寄出"
    else
      message = "此成員已加入！"
    end
    redirect_to root_path, notice: message
  end

  def destroy # 刪除邀請

    if @invite
      @invite.destroy
      message = "刪除成功！"
    else
      message = "操作失敗！"
    end

    redirect_to root_path, notice: message
  end

  def sign_up_and_join # 受邀者點連結註冊到這邊
    render "devise/registrations/new", locals: {
      resource:      User.new,
      resource_name: :user
    }
  end

  def join_to_organization # 已註冊受邀者點邀請到這邊

    unless @invite
      redirect_to root_path, notice: "無效的操作"
      return
    end

    create_org_user_link(
      current_user.id, 
      @invite.item_id, 
      'member'
    )

    @invite.destroy
    redirect_to root_path, notice: "歡迎加入"
  end

  private
  def params_injection
    # @name            = params[:name] # 寄件者顯示名稱
    @organization_id = params[:organization_id].to_i
    @email           = params[:email]
    @invite_token    = params[:invite_token]
    @invite = Invite.find_by(token: @invite_token) if @invite_token
  end

end
