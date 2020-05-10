class OrganizationRolesController < ApplicationController

  before_action :purview_check, only: [:change_role]

  def change_role
    user_id = params[:user_id]
    relationship = get_relationship(user_id)
    relationship.role = params[:role]
    relationship.save
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
      orgaznization_id: params[:orgaznization_id],
      user_id: user_id
    )
  end

end
