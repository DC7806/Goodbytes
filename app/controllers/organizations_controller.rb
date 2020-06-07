class OrganizationsController < ApplicationController
  before_action :find_organization, except: [:create]
  before_action :org_admin?,        except: [:create]

  def create
    organization = Organization.new(organization_params)
    if organization.save
      organization.update_role(current_user.id, admin)
      session["goodbytes7788"]["organization_id"] = organization.id
      session["goodbytes7788"]["channel_id"] = nil
      @notice = '組織新增成功'
    else
      @notice = "組織新增失敗"
    end
    redirect_to channel_path, notice: @notice
  end
  def edit
    # organization後台頁面
    @users = @organization.users_with_role
  end

  def update
    if @organization.update(organization_params)
      @notice = "組織更新成功"
    else
      @notice = "組織更新失敗"
    end
    redirect_to edit_organization_path, notice: @notice
  end

  def destroy
    if @organization.destroy
      clean_session
      @notice = "組織刪除成功"
    else
      @notice = "組織刪除失敗"
    end
    redirect_to root_path, notice: @notice 
  end

  def organization_params
    params.require(:organization).permit(
      :name
    )
  end


end
