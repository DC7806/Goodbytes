class OrganizationRolesController < ApplicationController

  before_action :purview_chec #, only: [:create, :update]

  def update
    user_id = params[:user_id]
    relationship = get_relationship(user_id)
    relationship.role = params[:role]
    relationship.save
  end

  def destroy
    org = Organization.find(params[:organization_id])
    user = org.users
              .find do |u| 
                u.id == params[:user_id] 
              end

    # 驗證token借role欄位放，所以如果沒有確認信件就不會變成上述角色          
    if ['admin','member'].include? user.role
      org.native_users.delete(user) # 開除員工
    else
      user.destroy # 取消邀請，直接把當初創建的暫存user資料刪除
    end
  end

  private
  def purview_check
    your_role = get_relationship(current_user.id).role
    if your_role != 'admin'
      redirect_to root_path, alert: '沒有權限進行此操作！'
    end
  end

  def get_relationship(user_id)
    OrganizationsUser.find_by(
      organization_id: params[:organization_id],
      user_id: user_id
    )
  end

end
