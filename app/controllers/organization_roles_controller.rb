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
    relationship = get_relationship(user_id)
       
    if relationship.role == 'admin'
      notice = "不能開除admin！"
    else
      relationship.destroy # 開除員工
      notice = "成功刪除！"
    end
    
    redirect_to root_path, notice: notice
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
