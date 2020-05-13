class OrganizationsController < ApplicationController
  before_action :admin? except: [:create]
  def create
    current_user.organizations.create(
      name: params[:name]
    )
    redirect_to root_path, notice: '新增成功～'
  end

  def update
  end

  def destroy
  end

end
