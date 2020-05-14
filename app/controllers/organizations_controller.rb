class OrganizationsController < ApplicationController
  before_action :org_admin?, except: [:create]
  def create
    organization = Organization.create(
      name: params[:name]
    )
    organization.update_role(current_user.id, 'admin')
    redirect_to root_path, notice: '新增成功～'
  end

  def update
  end

  def destroy
  end

end
