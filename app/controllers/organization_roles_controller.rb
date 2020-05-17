class OrganizationRolesController < ApplicationController

  before_action :org_admin?, only: [:update, :destroy]
  before_action :find_organization, except: [:new]

  def new
    params_require(:organization_id, :email)
    if current_user.send_invitation
                   .by_org(@organization_id)
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
    
    unless invite
      redirect_to root_path, notice: "無效的操作"
      return
    end

    @organization.update_role(
      current_user.id,
      'member'
    )

    invite.destroy
    redirect_to root_path, notice: "歡迎加入"
  end

  def update
    params_require(:user_id, :role)
    @organization.update_role(@user_id, @role)
  end

  def destroy
    params_require(:user_id)
    rel = @organization.relationship(@user_id)
    if rel.role == 'admin'
      notice = "不能開除admin！"
    else
      rel.destroy # 開除員工
      notice = "成功刪除！"
    end
    
    redirect_to root_path, notice: notice
  end

  private
  def find_organization
    @organization = Organization.find(params[:organization_id])
  end

end
