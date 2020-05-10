class OrganizationRolesController < ApplicationController

  before_action :purview_check #, only: [:create, :update]

  def update
    # 必要參數: organization_id, user_id, role
    user_id           = params[:user_id].to_i
    relationship      = get_relationship(user_id)
    relationship.role = params[:role]
    relationship.save
  end

  def destroy
    # 必要參數: organization_id, user_id
    org  = Organization.find(params[:organization_id].to_i)
    user = org.users_with_role
              .find do |u| 
                u.id == params[:user_id].to_i 
              end

    # 驗證token借role欄位放，所以如果沒有確認信件就不會變成上述角色          
    if role_list.include? user.role
      org.users.delete(user) # 開除員工
    else
      user.destroy # 取消邀請，直接把當初創建的暫存user資料刪除
    end
    redirect_to root_path, notice: "成功刪除！"
  end

  private
  def purview_check
    your_role     = get_relationship(current_user.id).role
    if your_role != 'admin'
      redirect_to root_path, alert: '沒有權限進行此操作！'
    end
  end

  def get_relationship(user_id)
    OrganizationsUser.find_by(
      organization_id: params[:organization_id].to_i,
      user_id:         user_id
    )
  end

end
