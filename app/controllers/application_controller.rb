class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  #logger.fatal self.class.to_s + "." + self.action_name
  
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end

  def org_admin?
    relationship = OrganizationsUser.find_by(
      organization_id: channel_params[:organization_id],
      user_id:         current_user.id
    )
    unless relationship && relationship.role=='admin'
      redirect_to root_path, notice: '沒有權限進行此操作！'
    end
  end
end
