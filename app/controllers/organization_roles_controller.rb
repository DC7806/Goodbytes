class OrganizationRolesController < ApplicationController

  before_action :admin?, except: [:get_organization_role]
  before_action :get_organization_role, except: [:admin?]
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

  def get_organization_role
    @relationship = OrganizationsUser.find_by(
      organization_id: params[:organization_id],
      user_id:         params[:user_id]
    )
  end

  

end
