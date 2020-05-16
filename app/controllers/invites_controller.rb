class InvitesController < ApplicationController

  before_action :params_injection
  skip_before_action :authenticate_user!, only: [:sign_up_and_join]

  def new
    params_require(:organization_id, :email)
    if @organization_id
      redirect_to new_organization_role_path(
        organization_id: @organization_id, 
        email: @email
      )
    end
  end

  def accept
    params_require(:organization_id, :invite_token)
    redirect_post(organization_role_index_path(organization_id: @organization_id),
      params: {organization_id: @organization_id, invite_token: @invite_token},   
      options: {
        method: :post,                  
        authenticity_token: 'auto',                  
        autosubmit: true
      }
    )
  end

  def destroy # 刪除邀請
    params_require(:invite_token)
    invite = Invite.find_by(token: @invite_token)
    if invite
      invite.destroy
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

  private
  def params_injection
    # @name            = params[:name] # 寄件者顯示名稱
    @organization_id = params[:organization_id].to_i
    @email           = params[:email]
    @invite_token    = params[:invite_token]
    @invite = Invite.find_by(token: @invite_token) if @invite_token
  end

end
