class InvitesController < ApplicationController

  before_action :params_injection
  def create
    # 必要參數: name organization_id email 
    # 發送邀請時使用此方法，會創一個預先準備好的user記錄以便後續追蹤confirm狀況
    # 不用怕重複，在registration controller我有改寫
    user            = User.find_by(email: @email)
    @invite_token   = generate_token(10)
    registable      = !Organization.find_by(name: @email)

    if not user
      user = User.new(
        email: @email, 
        password: @invite_token # 密碼必填，這邊隨便塞一個，到時受邀者來註冊直接蓋過去即可
      )
      user.save
    end

    organization_current_members = Organization.find(@organization_id).users_with_role
    relationship                 = organization_current_members.find{ |u| u.email == @email }
    unless relationship # 如果沒邀過這個人這邊會找不到，則建立新聯結
      relationship = OrganizationsUser.new(
        organization_id: @organization_id,
        user_id:         user.id,
        role:            @invite_token
      )
      relationship.save
    end

    unless role_list.include?(relationship.role) # 如果role是token則代表邀請過這個人，就使用之前在role留下的token
      @invite_token = relationship.role
      

      InviteMailerJob.perform_later(
        @name, 
        @organization_id, 
        @email, 
        @invite_token, 
        registable
      )

      redirect_to root_path, notice: "邀請信件已寄出"
    else
      redirect_to root_path, notice: "此成員已加入！"
    end
    
  end

  def sign_up_and_join # 受邀者點連結註冊到這邊
    render "devise/registrations/new", locals: {
      resource:      User.new,
      resource_name: :user
    }
  end

  def join_to_organization # 已註冊受邀者點邀請到這邊
    relationship = OrganizationsUser.find_by(
      organization_id: @organization_id, 
      user_id: current_user.id
    )
    relationship.role = 'member'
    relationship.save
    redirect_to root_path
  end

  private
  def params_injection
    # @name            = params[:name] # 寄件者顯示名稱
    @organization_id = params[:organization_id].to_i
    @name            = Organization.find(@organization_id).name
    @email           = params[:email]
    @invite_token    = params[:invite_token]
  end

end
