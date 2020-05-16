class OrganizationRolesController < ApplicationController

  before_action :org_admin?, only: [:update, :destroy]
  before_action :get_organization_role, only: [:update, :destroy]

  def new

    if current_user.send_invitation
                   .by_org(params[:organization_id])
                   .to(params[:email])
      message = "邀請信件已寄出"
    else
      message = "此成員已加入！"
    end
    redirect_to root_path, notice: message
  end

  def create
    organization_id = params[:organization_id]
    invite_token    = params[:invite_token]
    invite = Invite.find_by(token: invite_token) if invite_token
    
    unless invite
      redirect_to root_path, notice: "無效的操作"
      return
    end

    Organization.find(organization_id).update_role(
      current_user.id,
      'member'
    )

    invite.destroy
    redirect_to root_path, notice: "歡迎加入"
  end

  def update
    # 必要參數: organization_id, user_id, role
    @relationship.role = params[:role]
    @relationship.save
  end

  def destroy
    # 必要參數: organization_id, user_id
    if @relationship.role == 'admin'
      notice = "不能開除admin！"
    else
      @relationship.destroy # 開除員工
      notice = "成功刪除！"
    end
    
    redirect_to root_path, notice: notice
  end

  private
  def get_organization_role
    @relationship = OrganizationsUser.find_by(
      organization_id: params[:organization_id],
      user_id:         params[:user_id]
    )
  end

end
