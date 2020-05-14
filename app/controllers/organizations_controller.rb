class OrganizationsController < ApplicationController
  before_action :org_admin?, except: [:create]
  def create
    organization = create_organization(params[:name])
    create_org_user_link(current_user.id, organization.id, 'admin')
    redirect_to root_path, notice: '新增成功～'
  end

  def update
  end

  def destroy
  end

end
