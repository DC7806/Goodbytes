class OrganizationsController < ApplicationController
  before_action :find_organization, except: [:create]
  before_action :org_admin?, except: [:create]

  def create
    organization = Organization.new(organization_params)
    if organization.save
      organization.update_role(current_user.id, admin)
      notice = '新增成功～'
    else
      notice = "新增失敗"
    end
    redirect_to root_path, notice: notice
  end
  def edit
    # organization後台頁面
    @users = @organization.users_with_role
  end

  def update
    if @organization.update(organization_params)
      notice = "更新成功"
    else
      notice = "更新失敗"
    end
    redirect_to root_path, notice: notice
  end

  def destroy
    if @organization.destroy
      notice = "刪除成功"
    else
      notice = "刪除失敗"
    end
    redirect_to root_path, notice: notice 
  end

  def organization_params
    params.require(:organization).permit(
      :name
    )
  end


end
