class InvitesController < ApplicationController

  before_action :params_injection
  def create
    # 必要參數: name organization_id email 
    # 發送邀請時使用此方法，會創一個預先準備好的user記錄以便後續追蹤confirm狀況
    # 不用怕重複，在registration controller我有改寫
    user            = User.find_by(email: @email)
    @invite_token   = generate_token(10)
    registable      = !user
    organization = Organization.find(@organization_id)
    relationship = organization.users_with_role
                               .find{ |u| u.email == @email }
    unless relationship 
      organization.invites.create(
        token: @invite_token,
        sender_id: current_user.id,
        reciever: @email
      )

      InviteMailerJob.perform_later(
        Organization.find(@organization_id).name,
        @email, 
        @invite_token, 
        registable
      )

      redirect_to root_path, notice: "邀請信件已寄出"
    else
      redirect_to root_path, notice: "此成員已加入！"
    end
    
  end

  def destroy # 刪除邀請
    Invite.find(params[:invite_id]).destroy
    redirect_to root_path, notice: "刪除成功！"
  end

  def sign_up_and_join # 受邀者點連結註冊到這邊
    render "devise/registrations/new", locals: {
      resource:      User.new,
      resource_name: :user
    }
  end

  def join_to_organization # 已註冊受邀者點邀請到這邊
    relationship = OrganizationsUser.new(
      organization_id: @organization_id, 
      user_id:         current_user.id,
      role:            'member'
    )
    relationship.save
    redirect_to root_path, notice: "歡迎加入 #{@name} "
  end

  private
  def params_injection
    # @name            = params[:name] # 寄件者顯示名稱
    @organization_id = params[:organization_id].to_i
    @email           = params[:email]
    @invite_token    = params[:invite_token]
  end

end
